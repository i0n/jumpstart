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
    
    # Sets up JumpStart::Base object with preliminary instance variables.
    def initialize(args)
      # setup for testing input
      @input  = $stdin
      # setup for testing output
      @output = $stdout
      # set the name of the project from the first argument passed, or from the module instance variable JumpStart::Setup.default_template_name if no argument passed.
      @project_name = args.shift.dup if args[0] != nil
      if args[0] != nil
        @template_name = args.shift.dup
      elsif JumpStart::Setup.default_template_name != nil
        @template_name = JumpStart::Setup.default_template_name
      end
      # set instance variable @template_path as the directory to read templates from.
      @template_path = FileUtils.join_paths(JumpStart::Setup.templates_path, @template_name)
    end
    
    # Sets up instance variables from YAML file
    def set_config_file_options
      if @template_name.nil? || @template_path.nil?
        jumpstart_menu
      elsif File.exists?(FileUtils.join_paths(@template_path, '/jumpstart_config/',"#{@template_name}.yml"))
        @config_file = YAML.load_file(FileUtils.join_paths(@template_path, "/jumpstart_config/", "#{@template_name}.yml"))
        @install_command ||= @config_file[:install_command]
        @install_command_args ||= @config_file[:install_command_args]
        @replace_strings ||= @config_file[:replace_strings].each {|x| x}
        @install_path ||= @config_file[:install_path]
      else
        jumpstart_menu
      end
    end
    
    # Pre-install project configuration checking.
    def check_setup
      set_config_file_options
      lookup_existing_templates
      check_project_name
      check_template_name
      check_template_path
      check_install_path
    end
    
    # set up instance variable containing an array that will be populated with existing jumpstart templates
    def lookup_existing_templates
      @existing_templates = []
      template_dirs = Dir.entries(JumpStart::Setup.templates_path) - IGNORE_DIRS
      template_dirs.each do |x|
        if File.directory?(FileUtils.join_paths(JumpStart::Setup.templates_path, x))
          if Dir.entries(FileUtils.join_paths(JumpStart::Setup.templates_path, x)).include? "jumpstart_config"
            if File.exists?(FileUtils.join_paths(JumpStart::Setup.templates_path, x, '/jumpstart_config/', "#{x}.yml"))
              @existing_templates << x
            end
          end
        end
      end
    end
    
    # Runs the configuration, generating the new project from the chosen template.
    def start
      puts "\n******************************************************************************************************************************************\n\n"
      puts "  JumpStarting....\n".purple
      check_setup
      execute_install_command
      run_scripts_from_yaml(:run_after_install_command)
      parse_template_dir
      create_dirs
      populate_files_from_whole_templates
      populate_files_from_append_templates
      populate_files_from_line_templates
      remove_unwanted_files
      run_scripts_from_yaml(:run_after_jumpstart)
      check_for_strings_to_replace
      check_local_nginx_configuration
      exit_with_success
    end
    
    # Checks replace string values for :project_name and replaces these with the value of @project_name if found. This enables PROJECT_NAME entries in projects to be dynamically populated with the current project name.
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
    
    # Makes sure that the chosen project name is suitable. (Not nil or empty, at least 3 characters long, and starts with a letter or a number.) 
    # Returns with the value of @project_name
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
        @project_name = gets.chomp.strip
        check_project_name
      else
        @project_name
      end
    end
    
    # Launches the JumpStart menu system if a template has not been specified.
    def check_template_name
      if @template_name.nil? || @template_name.empty?
        jumpstart_menu
      end
    end
    
    # Ensures that the template path specified exists and can be accessed. Exits if an error occurs.
    def check_template_path
      begin
        Dir.chdir(@template_path)
      rescue
        puts "\nThe directory #{@template_path.red} could not be found, or you do not have the correct permissions to access it."
        exit_normal
      end
    end

    # Sets the install path to executing directory if @install_path varibale is nil or empty. This should result in projects being created in directory from which the jumpstart command was called, if the template specified does not set this option.
    # Checks the install path set in @install_path.
    # Checks that a directory with the same name as the project does not already exist in the install path.
    def check_install_path
      @install_path = system "pwd" if @install_path.nil? || @install_path.empty?
      if File.directory?(FileUtils.join_paths(@install_path, @project_name))
        puts "\nThe directory #{FileUtils.join_paths(@install_path, @project_name).red} already exists.\nAs this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything."
        exit_normal
      end
      true
    end
    
    # Creates a new blank template in whichever directory the default templates directory has been set to.
    def create_template
      if File.directory?(FileUtils.join_paths(JumpStart::Setup.templates_path, @template_name))
        puts "\nThe directory #{FileUtils.join_paths(JumpStart::Setup.templates_path, @template_name).red} already exists. The template will not be created."
        exit_normal
      else
        FileUtils.mkdir_p(FileUtils.join_paths(JumpStart::Setup.templates_path, @template_name, "/jumpstart_config"))
        yaml = IO.read(FileUtils.join_paths(ROOT_PATH, "/source_templates/template_config.yml"))
        File.open(FileUtils.join_paths(JumpStart::Setup.templates_path, @template_name, "/jumpstart_config", "#{@template_name}.yml"), 'w') do |file|
          file.puts yaml
        end
        puts "The template #{@template_name.green} has been generated.\n"
      end
    end
        
    # Displays options for the main jumpstart menu.
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
    
    # Captures user input for the main jumpstart menu and calls the appropriate method
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
    
    # Displays options for the "create a new jumpstart project from an existing template" menu
    def new_project_from_template_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "  CREATE A NEW JUMPSTART PROJECT FROM AN EXISTING TEMPLATE\n\n".purple
      puts "  Type a number for the template that you want.\n\n"
      count = 0
      unless @existing_templates.nil? || @existing_templates.empty?
        @existing_templates.each do |t|
          count += 1
          puts "  #{count.to_s.yellow} #{t}"
        end
      end
      puts "\n  b".yellow + " Back to main menu."
      puts "\n  x".yellow + " Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      new_project_from_template_options
    end
    
    # Captures user input for the "create a new jumpstart project from an existing template" menu and calls the appropriate method.
    # When the input matches a template number a project will be created from that template
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
    
    # Displays output for the "create a new jumpstart template" menu
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

    # Captures user input for "create a new jumpstart template" menu and calls the appropriate action.
    # If the template name provided meets the methods requirements then a directory of that name containing a jumpstart_config dir and matching yaml file are created.
    def new_template_options
      puts "\n  Enter a unique name for the new template.\n".yellow
      input = gets.chomp.strip
      case
      when @existing_templates.include?(input)
        puts "  A template of the name ".red + input.red_bold + " already exists.".red
        new_template_options
      when input.length < 3
        puts "  The template name ".red + input.red_bold + " is too short. Please enter a name that is at least 3 characters long.".red
        new_template_options
      when input.match(/^\W/)
        puts "  The template name ".red + input.red_bold + " begins with an invalid character. Please enter a name that begins with a letter or a number.".red
        new_template_options
      else
        FileUtils.mkdir_p(FileUtils.join_paths(JumpStart::Setup.templates_path, input, "jumpstart_config"))
        FileUtils.cp(FileUtils.join_paths(ROOT_PATH, "source_templates/template_config.yml"), FileUtils.join_paths(JumpStart::Setup.templates_path, input, "jumpstart_config", "#{input}.yml"))
        puts "  The template ".green + input.green_bold + " has been created in your default jumpstart template directory ".green + JumpStart::Setup.templates_path.green_bold + " ready for editing.".green
        jumpstart_menu
      end
    end
    
    # Displays output for the "jumpstart default template options menu"
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
    
    # Sets the default template to be used by JumpStart and writes it to a YAML file.
    def set_default_template_options
      input = gets.chomp.strip
      case
      when input.to_i <= @existing_templates.count && input.to_i > 0
        JumpStart::Setup.default_template_name = @existing_templates[(input.to_i - 1)]
        JumpStart::Setup.dump_jumpstart_setup_yaml
        puts "  The default jumpstart template has been set to: #{JumpStart::Setup.default_template_name.green}"
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
    
    # Displays output for the "jumpstart templates directory options" menu.
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
    
    # Captures user input for the "jumpstart templates directory options" menu and calls the appropriate method.
    def templates_dir_options
      input = gets.chomp.strip
      case
      when input == "1"
        set_templates_dir
      when input == "2"
        reset_templates_dir_to_default_check
      when input == "b"
        jumpstart_menu
      when input == "x"
        exit_normal
      else
        puts "That command hasn't been understood. Try again!".red
        templates_dir_options
      end
    end
    
    # Sets the path for templates to be used by JumpStart.
    # Copies templates in the existing template dir to the new location.
    # The folder specified must not exist yet, but it's parent should.
    def set_templates_dir
      puts "Please enter the absolute path for the directory that you would like to contain your jumpstart templates."
      input = gets.chomp.strip
      root_path = input.sub(/\/\w*\/*$/, '')
      case
      when File.directory?(input)
        puts "A directory of that name already exists, please choose a directory that does not exist."
        set_templates_dir
      when File.directory?(root_path)
        begin
          Dir.chdir(root_path)
          Dir.mkdir(input)
          files_and_dirs = FileUtils.sort_contained_files_and_dirs(JumpStart::Setup.templates_path)
          puts "\nCopying existing templates to #{input}"
          files_and_dirs[:dirs].each {|x| FileUtils.mkdir_p(FileUtils.join_paths(input, x))}
          files_and_dirs[:files].each {|x| FileUtils.cp(FileUtils.join_paths(JumpStart::Setup.templates_path, x), FileUtils.join_paths(input, x)) }
          JumpStart::Setup.templates_path = input.to_s
          JumpStart::Setup.dump_jumpstart_setup_yaml
          puts "\nTransfer complete!".green
          jumpstart_menu
        rescue
          puts "It looks like you do not have the correct permissions to create a directory in #{root_path.red}"
        end
      end
    end
    
    # Checks to see if the JumpStart template directory should be reset to the default location. (within the gem.)
    def reset_templates_dir_to_default_check
      if JumpStart::Setup.templates_path == "#{ROOT_PATH}/jumpstart_templates"
        puts "  You do not need to reset the jumpstart templates directory, it is already set to: #{ROOT_PATH}/jumpstart_templates\n\n".red
        templates_dir_menu
      else  
        puts "  Resetting the jumpstart templates directory to the default: #{ROOT_PATH}/jumpstart_templates\n\n"
        @current_files_and_dirs = FileUtils.sort_contained_files_and_dirs(JumpStart::Setup.templates_path)
        puts "  Moving your jumpstart templates back to the default directory will delete any templates that are currently there. Proceed?\n".yellow
        puts "  Type yes (" + "y".yellow + ") or no (" + "n".yellow + ")\n\n"
        reset_templates_dir_to_default_set
      end
    end
    
    # Resets the JumpStart template directory to the default location. (within the gem.)
    def reset_templates_dir_to_default_set
      input = gets.chomp.strip
      if input == "yes" || input == "y"
        FileUtils.delete_dir_contents(FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates'))
        FileUtils.touch(FileUtils.join_paths(ROOT_PATH, '.gitignore'))
        @current_files_and_dirs[:dirs].each {|x| FileUtils.mkdir_p(FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates', x))}
        @current_files_and_dirs[:files].each {|x| FileUtils.cp(FileUtils.join_paths(JumpStart::Setup.templates_path, x), FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates', x)) }
        JumpStart::Setup.templates_path = FileUtils.join_paths(ROOT_PATH, '/jumpstart_templates')
        JumpStart::Setup.dump_jumpstart_setup_yaml
        puts "\n  SUCCESS! the jumpstart templates directory has been set to the default: #{ROOT_PATH}/jumpstart_templates".green
        templates_dir_menu
      elsif input == "no" || input == "n"
        puts "\n You have chosen not to move the jumpstart templates directory, nothing has been changed."
        templates_dir_menu
      else
        puts "\n The command you entered could not be understood, please enter yes '" + "y".yellow + "' or no '" + "n".yellow + "'"
        reset_templates_dir_to_default_set
      end
    end

    # Runs the main install command specified in the selected templates YAML file.
    def execute_install_command
      Dir.chdir(@install_path)
      unless @install_command.nil? || @install_command.empty?
        puts "Executing command: #{@install_command.green} #{@project_name.green} #{@install_command_args.green}"
        system "#{@install_command} #{@project_name} #{@install_command_args}"
      end
    end

    # Parses the contents of the @template_path and sorts ready for template creation.
    def parse_template_dir
      @dir_list = []
      file_list = []
      @append_templates = []
      @line_templates = []
      @whole_templates = []
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
    
    # Makes folders for the project
    def create_dirs
      @dir_list.each {|dir| FileUtils.mkdir_p(FileUtils.join_paths(@install_path, @project_name, dir)) } unless @dir_list.nil?
    end
    
    # Create files from whole templates
    def populate_files_from_whole_templates
      @whole_templates.each {|x| FileUtils.cp(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, x)) } unless @whole_templates.nil?
    end

    # Create files from append (_._ _l._ or _L._) templates
    def populate_files_from_append_templates
      @append_templates.each do |x|
        new_name = x.sub(/_([lL]?)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.append_to_end_of_file(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.remove_last_line?(x))
      end
    end
    
    # Create files from line number templates (e.g. _12._ or _1._)
    def populate_files_from_line_templates
      @line_templates.each do |x|
        new_name = x.sub(/_(\d+)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.insert_text_at_line_number(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.get_line_number(x))
      end
    end

    # Checks to see if options for configuring a local Nginx environment have been specified in the template. If they have, runs the relevant JumpStart::FileTools class methods (included in FileUtils module.)
    def check_local_nginx_configuration
      if @nginx_local_template.nil? || @config_file[:local_nginx_conf].nil?
        puts "  \nNginx will not be configured as options have not been set for this."
      else
        FileUtils.config_nginx(@nginx_local_template, @config_file[:local_nginx_conf], @project_name)
        FileUtils.config_hosts("/etc/hosts", @project_name)
      end
    end
    
    # Removes files specified in templates YAML
    def remove_unwanted_files
      file_array = []
      root_path = FileUtils.join_paths(@install_path, @project_name)
      @config_file[:remove_files].each do |file|
        file_array << FileUtils.join_paths(root_path, file)
      end
      FileUtils.remove_files(file_array)
    end
    
    # Runs additional scripts specified in YAML. Runs one set after the install command has executed, and another after the templates have been generated.
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
    
    # Looks for strings IN_CAPS that are specified for replacement in the templates YAML
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
    
    # Exit after creating a project, dumping current setup information to YAML
    def exit_with_success
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Success! ".green + @project_name.green_bold + " has been created at: ".green + FileUtils.join_paths(@install_path, @project_name).green_bold + "\n\n".green
      puts "******************************************************************************************************************************************\n"
      JumpStart::Setup.dump_jumpstart_setup_yaml
      exit
    end

    # Exit normally, dumping current setup information to YAML
    def exit_normal
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Goodbye!\n\n"
      puts "******************************************************************************************************************************************\n"
      JumpStart::Setup.dump_jumpstart_setup_yaml
      exit
    end
      
    class << self

      # Class instance method that returns an integer to be used as the line number for line templates. Returns false if no match is found.
      def get_line_number(file_name)
        if file_name.match(/_(\d+)\._\w*/)
          number = file_name.match(/_(\d+)\._\w*/)[1]
          number.to_i
        else
          false
        end
      end

      # Class instance method that returns true or false for removing the last line of a file.
      # Append templates with the _l._ or _L._ prefix will return true.
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