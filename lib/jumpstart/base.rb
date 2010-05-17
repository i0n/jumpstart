module JumpStart
  class Base
    
    attr_accessor :project_name, :template_name, :existing_projects, :config_file, :install_path, :template_path, :install_command, :install_command_options
    attr_reader :dir_list, :whole_templates, :append_templates, :line_templates, :nginx_local_template, :nginx_remote_template

    def initialize(args)
      @project_name = args.shift
      if args[0] != nil
        @template_name = args.shift
      elsif DEFAULT_TEMPLATE_NAME != nil
        @template_name = DEFAULT_TEMPLATE_NAME
      end
      @existing_projects = []
      @config_file = YAML.load_file(FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name, "/jumpstart_config/", "#{@template_name}.yml"))
      @install_path = FileUtils.join_paths(@config_file[:install_path].to_s)
      @template_path = FileUtils.join_paths(JUMPSTART_TEMPLATES_PATH, @template_name)
      @install_command = @config_file[:install_command]
      @install_command_options = @config_file[:install_command_options]
      @replace_strings = @config_file[:replace_strings].each {|x| x}
    end
    
    def start
      puts
      puts "******************************************************************************************************************************************"
      puts
      puts "JumpStarting...."
      puts
      puts
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
      check_local_nginx_configuration
      remove_unwanted_files
      run_scripts_from_yaml(:run_after_jumpstart)
      check_for_strings_to_replace
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
        puts
        puts "Enter a name for your project."
        @project_name = gets.chomp
        if @project_name.length < 3
          puts
          puts "The name of your project must be at least 3 characters long."
          check_project_name
        end
      end
    end
    
    def check_template_name
      if @template_name.nil? || @template_name.empty?
        jumpstart_options
      else
        unless @existing_projects.include? @template_name
          puts "A JumpStart template of the name #{@template_name} doesn't exist, would you like to create it?\nyes (y) / no (n)?"
          puts
          input = gets.chomp
          if input == "yes" || input == "y"
            puts "creating JumpStart template #{@template_name}"
            # TODO Create functionality for creating templates if they do not exist
          elsif input == "no" || input == "n"
            exit_jumpstart
          end
        end
      end
    end
    
    def jumpstart_options
      global_options = {'c' => 'config'}
      templates = {}
      puts "******************************************************************************************************************************************"
      puts
      puts "jumpstart options!"
      puts
      puts "What would you like to do?"
      puts "To run an existing jumpstart enter it's number or it's name."
      puts
      count = 0
      @existing_projects.each do |x|
        count += 1
        templates[count.to_s] = x
        puts "#{count}: #{x}"
      end
      puts
      puts "To create a new jumpstart enter a name for it."
      puts
      puts "To view/set jumpstart configuration options type 'config' or 'c'."
      input = gets.chomp
      global_options.each do |x,y|
        if input == 'c' || input == 'config'
          configure_jumpstart
        end
      end
      templates.each do |x,y|
        if x == input
          @template_name = templates.fetch(x)
        elsif y == input
          @template_name = y
        end
      end      
    end
        
    def configure_jumpstart
      # TODO Define configure_jumpstart method
      puts "******************************************************************************************************************************************"
      puts
      puts "jumpstart configuration."
      puts
      
      # This should be removed when method is finished.
      exit_jumpstart
    end
    
    def check_install_paths
      [@install_path, @template_path].each do |x|
        begin
          Dir.chdir(x)
        rescue
          puts
          puts "The directory #{x} could not be found, or you do not have the correct permissions to access it."
          exit_jumpstart
        end
      end
      if Dir.exists?(FileUtils.join_paths(@install_path, @project_name))
        puts
        puts "The directory #{FileUtils.join_paths(@install_path, @project_name)} already exists. As this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything."
        exit_jumpstart
      end
    end
        
    def create_project
      Dir.chdir(@install_path)
      unless @install_command.nil?
        puts "Executing command: #{@install_command} #{@project_name} #{@install_command_options}"
        system "#{@install_command} #{@project_name} #{@install_command_options}"
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
    
    # TODO Look at refactoring to remove duplicate regex
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
        FileUtils.join_paths(root_path, file)
        file_array << file
      end
      FileUtils.remove_files(file_array)
    end
    
    def run_scripts_from_yaml(script_name)
      unless @config_file[script_name].nil? || @config_file[script_name].empty?
        begin
          Dir.chdir("#{@install_path}/#{@project_name}")
          @config_file[script_name].each do |x|
            puts
            puts "Executing command: #{x}"
            system "#{x}"
          end
        rescue
          puts
          puts "Could not access the directory #{FileUtils.join_paths(@install_path, @project_name)}. In the interest of safety JumpStart will NOT run any YAML scripts from #{script_name} until it can change into the new projects home directory."
        end
      end
    end
    
    def check_for_strings_to_replace
      unless @replace_strings.nil?
        puts
        puts "Checking for strings to replace inside files..."
        puts
        @replace_strings.each do |file|
          puts "Target file: #{file[:target_path]}"
          puts
          puts "Strings to replace:"
          puts
          check_replace_string_pairs_for_project_name_sub(file[:symbols])
          file[:symbols].each do |x,y|
            puts "Key:    #{x}"
            puts "Value:  #{y}"
            puts
          end
          puts
          puts
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
    end
    
    def exit_jumpstart
      puts
      puts
      puts "Exiting JumpStart..."
      puts "Goodbye!"
      puts
      puts "******************************************************************************************************************************************"
      puts
      exit
    end
    
    class << self
      
      def get_line_number(file_name)
        /_(?<number>\d+)\._\w*/ =~ file_name
        number.to_i
      end
      
      def remove_last_line?(file_name)
        /_(?<remove_last_line>[lL]{1})\._{1}\w*/ =~ file_name
        if remove_last_line.nil?
          false
        else
          true
        end
      end
      
    end
    
  end
end