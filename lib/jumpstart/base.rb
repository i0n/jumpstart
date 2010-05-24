module JumpStart
  class Base
        
    # Accessor methods to make testing input or output easier.
    attr_accessor :input, :output

    # Monkeypatch gets to make testing easier.
    def gets(*args)
      @input.gets(*args)
    end
    
    # Monkeypatch puts to make testing easier.
    def puts(*args)
      @output.puts(*args)    
    end
    
    # TODO initialize needs more tests
    def initialize(args)
      # setup for testing input
      @input  = $stdin
      # setup for testing output
      @output = $stdout
      # The path to the jumpstart templates directory
      @jumpstart_templates_path = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:jumpstart_templates_path]
      # sets the default template to use if it has not been passed as an argument.
      @default_template_name = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:default_template_name]
      # set the name of the project from the first argument passed, or from the constant @default_template_name if no argument passed.
      @project_name = args.shift.dup if args[0] != nil
      if args[0] != nil
        @template_name = args.shift.dup
      elsif @default_template_name != nil
        @template_name = @default_template_name
      end
      # set instance variable @template_path as the directory to read templates from.
      @template_path = FileUtils.join_paths(@jumpstart_templates_path, @template_name)
      # set up instance variable containing an array that will be populated with existing jumpstart templates
    end
    
    # TODO Refactor startup so that if one argument is passed to the jumpstart command it will assume that it is the projects name.
    # If a default template has been set, jumpstart should create the project.
    # If a default template has not been set then the user should be asked to select an existing template. This could be the same menu as displayed for option 1 above.
    
    # TODO Ensure that if jumpstart is launched with two arguments they are parsed as @project_name and @template_name, and the command is launched without any menu display.
    # TODO Ensure that if jumpstart is launched with one argument it is parsed as @project_name, and if @default_template_name exists then the command is launched without any menu display.
    # TODO Document methods for RDOC
    # Finish README etc for github
    
    # TODO set_config_file_options needs tests
    def set_config_file_options
      if File.exists?(FileUtils.join_paths(@jumpstart_templates_path, @template_name, "/jumpstart_config/", "#{@template_name}.yml"))
        @config_file = YAML.load_file(FileUtils.join_paths(@jumpstart_templates_path, @template_name, "/jumpstart_config/", "#{@template_name}.yml"))
        @install_command ||= @config_file[:install_command]
        @install_command_args ||= @config_file[:install_command_args]
        @replace_strings ||= @config_file[:replace_strings].each {|x| x}
        @install_path ||= FileUtils.join_paths(@config_file[:install_path])
      else
        jumpstart_menu
      end
    end
    
    # TODO check_setup needs tests
    def check_setup
      set_config_file_options
      lookup_existing_templates
      check_project_name
      check_template_name
      check_template_path
      check_install_path
    end
    
    # TODO lookup_existing_templates needs tests
    def lookup_existing_templates
      @existing_templates = []
      template_dirs = Dir.entries(@jumpstart_templates_path) - IGNORE_DIRS
      template_dirs.each do |x|
        if Dir.entries(FileUtils.join_paths(@jumpstart_templates_path, x)).include? "jumpstart_config"
          if File.exists?(FileUtils.join_paths(@jumpstart_templates_path, x, '/jumpstart_config/', "#{x}.yml"))
            @existing_templates << x
          end
        end
      end
    end
    
    def start
      puts "\n******************************************************************************************************************************************\n\n"
      puts "JumpStarting....\n".purple
      check_setup
      execute_install_command
      run_scripts_from_yaml(:run_after_install_command)
      parse_template_dir
      # makes folders for the project
      @dir_list.each {|dir| FileUtils.mkdir_p(FileUtils.join_paths(@install_path, @project_name, dir)) }
      # create files from whole templates
      @whole_templates.each {|x| FileUtils.cp(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, x)) }
      populate_files_from_append_templates
      populate_files_from_line_templates
      remove_unwanted_files
      run_scripts_from_yaml(:run_after_jumpstart)
      check_for_strings_to_replace
      check_local_nginx_configuration
      exit_with_success
    end
    
    def check_replace_string_pairs_for_project_name_sub(hash)
      unless @project_name.nil?
        hash.each do |key, value|
          if key == :project_name
            hash[key] = @project_name
          end
        end
      end
      hash
    end
    
    private
    
    # TODO check_project_name needs extra tests for the match elsif
    def check_project_name
      if @project_name.nil? || @project_name.empty?
        puts "\n  Enter a name for your project.".yellow
        @project_name = gets.chomp.strip
        check_project_name
      elsif @project_name.length < 3
        puts "\n  The name #{@project_name} is too short. Please enter a name at least 3 characters long.".red
        @project_name = gets.chomp.strip
        check_project_name
      elsif @project_name.match(/^\W/)
        puts "\n  #{@project_name} begins with an invalid character. Please enter a name thats starts with a letter or a number.".red
        check_project_name
      else
        @project_name
      end
    end
    
    # TODO check_template_name needs tests.
    def check_template_name
      if @template_name.nil? || @template_name.empty?
        jumpstart_menu
      end
    end
    
    # TODO check_template_path needs tests
    def check_template_path
      begin
        Dir.chdir(@template_path)
      rescue
        puts "\nThe directory #{x.red} could not be found, or you do not have the correct permissions to access it."
        exit_normal
      end
    end
        
    # TODO check_install_path needs tests
    def check_install_path
      @install_path = FileUtils.pwd if @install_path.nil?
      if Dir.exists?(FileUtils.join_paths(@install_path, @project_name))
        puts
        puts "The directory #{FileUtils.join_paths(@install_path, @project_name).red} already exists.\nAs this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything."
        exit_normal
      end      
    end
           
    # TODO create_template needs tests
    def create_template
      if Dir.exists?(FileUtils.join_paths(@jumpstart_templates_path, @template_name))
        puts "\nThe directory #{FileUtils.join_paths(@jumpstart_templates_path, @template_name).red} already exists. The template will not be created."
        exit_normal
      else
        FileUtils.mkdir_p(FileUtils.join_paths(@jumpstart_templates_path, @template_name, "/jumpstart_config"))
        yaml = IO.read(FileUtils.join_paths(ROOT_PATH, "/source_templates/template_config.yml"))
        File.open(FileUtils.join_paths(@jumpstart_templates_path, @template_name, "/jumpstart_config", "#{@template_name}.yml"), 'w') do |file|
          file.puts yaml
        end
        puts "The template #{@template_name.green} has been generated.\n"
      end
    end
        
    # TODO jumpstart_menu needs tests
    def jumpstart_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  JUMPSTART MENU\n".purple
      puts "  Here are your options:\n\n"
      puts "  1".yellow + " Create a new project from an existing template.\n"
      puts "  2".yellow + " Create a new template.\n"
      puts "  3".yellow + " Set the default template.\n"
      puts "  4".yellow + " Set the templates directory.\n\n"
      puts "  x".yellow + " Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      jumpstart_menu_options
    end
    
    # TODO jumpstart_menu_options needs tests
    def jumpstart_menu_options
      lookup_existing_templates
      input = gets.chomp.strip
      case
      when input == "1"
        new_project_from_template_menu
      when input == "2"
        new_template_menu
      when input == "3"
        set_default_template_menu
      when input == "4"
        templates_dir_menu
      when input == "x"
        exit_normal
      else
        puts "That command hasn't been understood. Try again!".red
        jumpstart_menu_options
      end
    end
    
    # TODO Check/finish methods for creating a new project through the menu
    # TODO new_project_from_template_menu needs tests
    def new_project_from_template_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  CREATE A NEW JUMPSTART PROJECT FROM AN EXISTING TEMPLATE\n\n".purple
      puts "  Type a number for the template that you want.\n\n"
      count = 0
      @existing_templates.each do |t|
        count += 1
        puts "  #{count.to_s.yellow} #{t}"
      end
      puts "\n  b".yellow + " Back to main menu."
      puts "\n  x".yellow + " Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      new_project_from_template_options
    end
    
    # TODO new_project_from_template_options needs tests
    def new_project_from_template_options
      input = gets.chomp.strip
      case
      when input.to_i <= @existing_templates.count && input.to_i > 0
        @template_name = @existing_templates[(input.to_i - 1)]
        check_project_name
        project = JumpStart::Base.new([@project_name, @template_name])
        project.check_setup
        project.start
      when input == "b"
        jumpstart_menu
      when input == "x"
        exit_normal
      else
        puts "That command hasn't been understood. Try again!".red
      end
    end
    
    # TODO write tests for new_template_menu
    def new_template_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  CREATE A NEW JUMPSTART TEMPLATE\n".purple
      puts "  Existing templates:\n"
      lookup_existing_templates
      @existing_templates.each do |x|
        puts "  #{x.green}\n"
      end
      new_template_options
    end
    
    # TODO add functionality for duplicating an existing template
    # TODO write tests for new_template_options
    def new_template_options
      puts "\n  Enter a unique name for the new template.\n".yellow
      input = gets.chomp.strip
      if @existing_templates.include?(input)
        puts "  A template of the name ".red + input.red_bold + " already exists.".red
        new_template_options
      elsif input.length < 3
        puts "  The template name ".red + input.red_bold + " is too short. Please enter a name that is at least 3 characters long.".red
        new_template_options
      elsif input.match(/^\W/)
        puts "  The template name ".red + input.red_bold + " begins with an invalid character. Please enter a name that begins with a letter or a number.".red
        new_template_options
      else
        FileUtils.mkdir_p(FileUtils.join_paths(@jumpstart_templates_path, input, "jumpstart_config"))
        FileUtils.cp(FileUtils.join_paths(ROOT_PATH, "source_templates/template_config.yml"), FileUtils.join_paths(@jumpstart_templates_path, input, "jumpstart_config", "#{input}.yml"))
        puts "  The template ".green + input.green_bold + " has been created in your default jumpstart template directory ".green + @jumpstart_templates_path.green_bold + " ready for editing.".green
        jumpstart_menu
      end
    end
    
    # TODO Write method(s) for setting the default template
    def set_default_template_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  JUMPSTART DEFAULT TEMPLATE OPTIONS\n\n".purple
      count = 0
      @existing_templates.each do |t|
        count += 1
        puts "  #{count.to_s.yellow} #{t}"
      end
      puts "\n  b".yellow + " Back to main menu.\n\n"
      puts "  x".yellow + " Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      set_default_template_options
    end
    
    # Sets the default template to be used by JumpStart.
    def set_default_template_options
      input = gets.chomp.strip
      case
      when input.to_i <= @existing_templates.count && input.to_i > 0
        @default_template_name = @existing_templates[(input.to_i - 1)]
        dump_global_yaml
        puts "  The default jumpstart template has been set to: #{@default_template_name.green}"
        jumpstart_menu
      when input == "b"
        jumpstart_menu
      when input == "x"
        exit_normal
      else
        puts "That command hasn't been understood. Try again!".red
        set_default_template_options
      end
    end
    
    # TODO write tests for templates_dir_menu
    def templates_dir_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  JUMPSTART TEMPLATES DIRECTORY OPTIONS\n\n".purple
      puts "  1".yellow + " Set templates directory.\n"
      puts "  2".yellow + " Reset templates directory to default\n\n"
      puts "  b".yellow + " Back to main menu.\n\n"
      puts "  x".yellow + " Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      templates_dir_options
    end
    
    # TODO templates_dir_options needs tests
    def templates_dir_options
      input = gets.chomp.strip
      case
      when input == "1"
        set_templates_dir
      when input == "2"
        reset_templates_dir_to_default
      when input == "b"
        jumpstart_menu
      when input == "x"
        exit_normal
      else
        puts "That command hasn't been understood. Try again!".red
        templates_dir_options
      end
    end
    
    # TODO set_templates_dir needs tests
    # Sets the path for templates to be used by JumpStart.
    def set_templates_dir
      puts "Please enter the absolute path for the directory that you would like to contain your jumpstart templates."
      input = gets.chomp.strip
      root_path = input.sub(/\/\w*\/*$/, '')
      case
      when Dir.exists?(input)
        puts "A directory of that name already exists, please choose a directory that does not exist."
        set_template_dir
      when Dir.exists?(root_path)
        begin
          Dir.chdir(root_path)
          Dir.mkdir(input)
          files_and_dirs = FileUtils.sort_contained_files_and_dirs(@jumpstart_templates_path)
          puts "\nCopying existing templates to #{input}"
          files_and_dirs[:dirs].each {|x| FileUtils.mkdir_p(FileUtils.join_paths(input, x))}
          files_and_dirs[:files].each {|x| FileUtils.cp(FileUtils.join_paths(@jumpstart_templates_path, x), FileUtils.join_paths(input, x)) }
          @jumpstart_templates_path = input.to_s
          dump_global_yaml
          puts "\nTransfer complete!".green
          jumpstart_menu
        rescue
          puts "It looks like you do not have the correct permissions to create a directory in #{root_path.red}"
        end
      end
    end
    
    # TODO reset_templates_dir_to_default needs tests
    # Resets the JumpStart template directory to the default location. (within the gem.)
    def reset_templates_dir_to_default
      if @jumpstart_templates_path == "#{ROOT_PATH}/jumpstart_templates"
        puts "  You do not need to reset the jumpstart templates directory, it is already set to: #{ROOT_PATH}/jumpstart_templates\n\n".red
      else  
        puts "  Resetting the jumpstart templates directory to the default: #{ROOT_PATH}/jumpstart_templates\n\n"
        current_files_and_dirs = FileUtils.sort_contained_files_and_dirs(@jumpstart_templates_path)
        puts "  Moving your jumpstart templates back to the default directory will delete any templates that are currently there. Proceed?\n".yellow
        puts "  Type yes (" + "y".yellow + ") or no (" + "n".yellow + ")\n\n"
        input = gets.chomp.strip
        if input == "yes" || input == "y"
          FileUtils.delete_dir_contents(FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates'))
          current_files_and_dirs[:dirs].each {|x| FileUtils.mkdir_p(FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates', x))}
          current_files_and_dirs[:files].each {|x| FileUtils.cp(FileUtils.join_paths(@jumpstart_templates_path, x), FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates', x)) }
          @jumpstart_templates_path = FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates')
          dump_global_yaml
          puts "\n  SUCCESS! the jumpstart templates directory has been set to the default: #{ROOT_PATH}/jumpstart_templates".green
        end
      end
      templates_dir_menu
    end
            
    # TODO execute_install_command needs tests
    def execute_install_command
      Dir.chdir(@install_path)
      unless @install_command.nil?
        puts "Executing command: #{@install_command.green} #{@project_name.green} #{@install_command_args.green}"
        system "#{@install_command} #{@project_name} #{@install_command_args}"
      end
    end
            
    # TODO parse_template_dir needs tests
    def parse_template_dir
      @dir_list = []
      file_list = []
      @whole_templates = []
      @append_templates = []
      @line_templates = []
      Find.find(@template_path) do |x|
        case
        when File.file?(x) && x !~ /\/jumpstart_config/ then
          file_list << x.sub!(@template_path, '')
        when File.directory?(x) && x !~ /\/jumpstart_config/ then
          @dir_list << x.sub!(@template_path, '')
        when File.file?(x) && x =~ /\/jumpstart_config\/nginx.local.conf/ then
          @nginx_local_template = x
        when File.file?(x) && x =~ /\/jumpstart_config\/nginx.remote.conf/ then
          @nginx_remote_template = x
        end
      end
      file_list.each do |file|
        if file =~ /_([lL]?)\._{1}\w*/
          @append_templates << file
        elsif file =~ /_(\d+)\._{1}\w*/
          @line_templates << file
        else
          @whole_templates << file
        end
      end
    end
                              
    #TODO populate_files_from_append_templates needs tests
    def populate_files_from_append_templates
      @append_templates.each do |x|
        new_name = x.sub(/_([lL]?)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.append_to_end_of_file(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.remove_last_line?(x))
      end
    end
    
    # TODO populate_files_from_line_templates needs tests
    def populate_files_from_line_templates
      @line_templates.each do |x|
        new_name = x.sub(/_(\d+)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.insert_text_at_line_number(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.get_line_number(x))
      end
    end
    
    # TODO check_local_nginx_configuration needs tests
    def check_local_nginx_configuration
      unless @nginx_local_template.nil? && @config_file[:local_nginx_conf].nil?
        FileUtils.config_nginx(@nginx_local_template, @config_file[:local_nginx_conf], @project_name)
        FileUtils.config_hosts("/etc/hosts", @project_name)
      end
    end
    
    def remove_unwanted_files
      file_array = []
      root_path = FileUtils.join_paths(@install_path, @project_name)
      @config_file[:remove_files].each do |file|
        file_array << FileUtils.join_paths(root_path, file)
      end
      FileUtils.remove_files(file_array)
    end
    
    def run_scripts_from_yaml(script_name)
      unless @config_file[script_name].nil? || @config_file[script_name].empty?
        begin
          Dir.chdir(FileUtils.join_paths(@install_path, @project_name))
          @config_file[script_name].each do |x|
            puts "\nExecuting command: #{x.green}"
            system "#{x}"
          end
        rescue
          puts "\nCould not access the directory #{FileUtils.join_paths(@install_path, @project_name).red}.\nIn the interest of safety JumpStart will NOT run any YAML scripts from #{script_name.to_s.red_bold} until it can change into the new projects home directory."
        end
      end
    end
    
    def check_for_strings_to_replace
      if @replace_strings.nil? || @replace_strings.empty?
        false
      else
        puts "\nChecking for strings to replace inside files...\n\n"
        @replace_strings.each do |file|
          puts "Target file: #{file[:target_path].green}\n"
          puts "Strings to replace:\n\n"
          check_replace_string_pairs_for_project_name_sub(file[:symbols])
          file[:symbols].each do |x,y|
            puts "Key:    #{x.to_s.green}"
            puts "Value:  #{y.to_s.green}\n\n"
          end
          puts "\n"
          path = FileUtils.join_paths(@install_path, @project_name, file[:target_path])
          FileUtils.replace_strings(path, file[:symbols])
        end
      end
    end
        
    def dump_global_yaml
      File.open( "#{CONFIG_PATH}/jumpstart_setup.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_templates_path => @jumpstart_templates_path, :default_template_name => @default_template_name}, out )
      end
    end
    
    def exit_with_success
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Success! ".green + @project_name.green_bold + " has been created at: ".green + FileUtils.join_paths(@install_path, @project_name).green_bold + "\n\n".green
      puts "******************************************************************************************************************************************\n"
      exit
    end
    
    def exit_normal
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Goodbye!\n\n"
      puts "******************************************************************************************************************************************\n"
      exit
    end
      
    class << self

      def get_line_number(file_name)
        if file_name.match(/_(\d+)\._\w*/)
          number = file_name.match(/_(\d+)\._\w*/)[1]
          number.to_i
        else
          false
        end
      end

      def remove_last_line?(file_name)
        if file_name.match(/_([lL]{1})\._{1}\w*/)
          true
        else
          false
        end
      end
      
    end
      
  end
end