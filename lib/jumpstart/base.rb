module JumpStart
  class Base
    
    attr_accessor :input, :output, :project_name, :template_name, :existing_projects, :config_file, :install_path, :template_path, :install_command, :install_command_options, :replace_strings
    attr_reader :dir_list, :whole_templates, :append_templates, :line_templates, :nginx_local_template, :nginx_remote_template

    # Monkeypatch puts to make testing easier.
    def puts(*args)
      @output.puts(*args)    
    end

    # Monkeypatch gets to make testing easier.
    def gets(*args)
      @input.gets(*args)
    end
    
    def initialize(args)
      @input  = $stdin
      @output = $stdout
      @project_name = args.shift.dup if args[0] != nil
      if args[0] != nil
        @template_name = args.shift.dup
      elsif DEFAULT_TEMPLATE_NAME != nil
        @template_name = DEFAULT_TEMPLATE_NAME
      end
      @existing_projects = []
      @config_file = YAML.load_file(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name, "/jumpstart_config/", "#{@template_name}.yml"))
      @install_path = FileUtils.join_paths(@config_file[:install_path].to_s)
      @template_path = FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name)
      @install_command = @config_file[:install_command]
      @install_command_args = @config_file[:install_command_args]
      @replace_strings = @config_file[:replace_strings].each {|x| x}
    end
        
    # TODO Refactor startup so that if one argument is passed to the jumpstart command it will assume that it is the projects name.
    # If a default template has been set, jumpstart should create the project.
    # If a default template has not been set then the user should be asked to select an existing template. This could be the same menu as displayed for option 1 above.
    
    # TODO Ensure that if jumpstart is launched with two arguments they are parsed as @project_name and @template_name, and the command is launched without any menu display.
    # TODO Ensure that if jumpstart is launched with one argument it is parsed as @project_name, and if DEFAULT_TEMPLATE_NAME exists then the command is launched without any menu display.
    
    def start
      puts "\n******************************************************************************************************************************************\n\n"
      puts "JumpStarting....\n".purple
      lookup_existing_projects
      check_project_name
      check_template_name
      check_install_paths
      create_project
      run_scripts_from_yaml(:run_after_install_command)
      parse_template_dir
      create_new_folders
      create_new_files_from_whole_templates
      populate_files_from_append_templates
      populate_files_from_line_templates
      remove_unwanted_files
      run_scripts_from_yaml(:run_after_jumpstart)
      check_for_strings_to_replace
      check_local_nginx_configuration
    end
        
    def lookup_existing_projects
      project_dirs = Dir.entries(JUMPSTART_TEMPLATES_PATH) -IGNORE_DIRS
      project_dirs.each do |x|
        if Dir.entries(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, x)).include? "jumpstart_config"
          if File.exists?(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, x, '/jumpstart_config/', "#{x}.yml"))
            @existing_projects << x
          end
        end
      end
    end
    
    def check_project_name
      if @project_name.nil? || @project_name.empty?
        puts "\nEnter a name for your project.".yellow
        @project_name = gets.chomp
        check_project_name
      elsif @project_name.length < 3
        puts "\nThe name of your project must be at least 3 characters long. Please enter a valid name.".yellow
        @project_name = gets.chomp
        check_project_name
      else
        @project_name
      end
    end
    
    def check_template_name
      if @template_name.nil? || @template_name.empty?
        jumpstart_menu
      else
        unless @existing_projects.include? @template_name
          puts "A JumpStart template of the name #{@template_name} doesn't exist, would you like to create it?\n yes (" + "y".yellow + ") / no (" + "n".yellow + ")?\n"
          input = gets.chomp
          if input == "yes" || input == "y"
            puts "creating JumpStart template #{@template_name}"
            create_template
          elsif input == "no" || input == "n"
            exit_jumpstart
          end
        end
      end
    end
    
    def create_template
      if Dir.exists?(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name))
        puts "\nThe directory #{FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name).red} already exists. The template will not be created."
        exit_jumpstart
      else
        FileUtils.mkdir_p(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name, "/jumpstart_config"))
        yaml = IO.read(FileUtils.join_paths(ROOT_PATH, "/source_templates/template_config.yml"))
        File.open(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name, "/jumpstart_config", "#{@template_name}.yml"), 'w') do |file|
          file.puts yaml
        end
        puts "The template #{@template_name.green} has been generated.\n"
      end
    end
    
    # TODO Refactor startup so that if no arguments are passed to the jumpstart command it launches an options menu
    # Options in the menu should include:
    # 1. Create a new project from template
    # 2. Create a new template
    # 3. Set default template
    
    def jumpstart_menu
      puts "\n\n******************************************************************************************************************************************\n\n"
      puts "JUMPSTART MENU\n\n".purple
      puts "Type a number for the option you want.\n\n"
      puts "1".yellow + " Create a new project from an existing template\n"
      puts "2".yellow + " Create a new template\n"
      puts "3".yellow + " Set default template\n\n"
      puts "x".yellow + "Exit jumpstart\n\n"
      puts "******************************************************************************************************************************************\n\n"
      jumpstart_menu_options
    end
    
    def jumpstart_menu_options
      input = gets.chomp
      case
      when input == "1"
        new_project_from_template_menu
      when input == "2"
        new_template_menu
      when input == "3"
        set_default_template_menu
      when inpuy == "x"
        exit_jumpstart
      else
        puts "That command hasn't been understood. Try again!".red
      end
    end
    
    def new_project_from_template_menu

    end
    
    def new_template_menu
      
    end
    
    def set_default_template_menu
      
    end
    
    # Sets the default template to be used by JumpStart.
    def set_default_template
      
    end
            
    def check_install_paths
      [@install_path, @template_path].each do |x|
        begin
          Dir.chdir(x)
        rescue
          puts "\nThe directory #{x.red} could not be found, or you do not have the correct permissions to access it."
          exit_jumpstart
        end
      end
      if Dir.exists?(FileUtils.join_paths(@install_path, @project_name))
        puts
        puts "The directory #{FileUtils.join_paths(@install_path, @project_name).red} already exists.\nAs this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything."
        exit_jumpstart
      end
    end
        
    def create_project
      Dir.chdir(@install_path)
      unless @install_command.nil?
        puts "Executing command: #{@install_command.green} #{@project_name.green} #{@install_command_args.green}"
        system "#{@install_command} #{@project_name} #{@install_command_args}"
      end
    end
            
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
    
    def create_new_folders
      Dir.chdir(@install_path)
      @dir_list.each do |x|
        unless Dir.exists?(FileUtils.join_paths(@install_path, @project_name, x))
          Dir.mkdir(FileUtils.join_paths(@install_path, @project_name, x))
        end
      end
    end
    
    def create_new_files_from_whole_templates
      @whole_templates.each do |x|
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, x))
        file_contents = IO.readlines(FileUtils.join_paths(@template_path, x))
        File.open(FileUtils.join_paths(@install_path, @project_name, x), "w") do |y|
          y.puts file_contents
        end
      end
    end
    
    def populate_files_from_append_templates
      @append_templates.each do |x|
        new_name = x.sub(/_([lL]?)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.append_to_end_of_file(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.remove_last_line?(x))
      end
    end
    
    def populate_files_from_line_templates
      @line_templates.each do |x|
        new_name = x.sub(/_(\d+)\._{1}/, '')
        FileUtils.touch(FileUtils.join_paths(@install_path, @project_name, new_name))
        FileUtils.insert_text_at_line_number(FileUtils.join_paths(@template_path, x), FileUtils.join_paths(@install_path, @project_name, new_name), JumpStart::Base.get_line_number(x))
      end
    end
    
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
    
    def exit_jumpstart
      puts "\n\nExiting JumpStart...".purple
      puts "Goodbye!\n"
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