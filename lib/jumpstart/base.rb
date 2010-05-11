module JumpStart
  class Base

    def initialize(args)
      @project_name = args.shift
      if args[0] != nil
        @template_name = args.shift
      elsif DEFAULT_TEMPLATE_NAME != nil
        @template_name = DEFAULT_TEMPLATE_NAME
      end
      @existing_projects = []
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
      load_config_options
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
    end
    
    private
        
    def lookup_existing_projects
      project_dirs = Dir.entries(JUMPSTART_TEMPLATES_PATH) -IGNORE_DIRS
      project_dirs.each do |x|
        if Dir.entries("#{JUMPSTART_TEMPLATES_PATH}/#{x}").include? "jumpstart_config"
          if File.exists?("#{JUMPSTART_TEMPLATES_PATH}/#{x}/jumpstart_config/#{x}.yml")
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
      projects.each do |x,y|
        if x == input
          @template_name = projects.fetch(x)
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
    
    def load_config_options
      @config_file = YAML.load_file("#{JUMPSTART_TEMPLATES_PATH}/#{@template_name}/jumpstart_config/#{@template_name}.yml")
    end
    
    def check_install_paths
      @install_path = @config_file[:install_path]
      @template_path = "#{JUMPSTART_TEMPLATES_PATH}/#{@template_name}"
      [@install_path, @template_path].each do |x|
        begin
          Dir.chdir(x)
        rescue
          puts
          puts "The directory #{x} could not be found, or you do not have the correct permissions to access it."
          exit_jumpstart
        end
      end
      if Dir.exists?("#{@install_path}/#{@project_name}")
        puts
        puts "The directory #{@install_path}/#{@project_name} already exists. As this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything."
        exit_jumpstart
      end
    end
        
    def create_project
      @install_command = @config_file[:install_command]
      @install_command_options = @config_file[:install_command_options]
      Dir.chdir(@install_path)
      puts "Executing command: #{@install_command} #{@project_name} #{@install_command_options}"
      system "#{@install_command} #{@project_name} #{@install_command_options}"
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
        when File.file?(x) && =~ /\/jumpstart_config\/nginx.local.conf/ then
          @nginx_local_template = x
        when File.file?(x) && =~ /\/jumpstart_config\/nginx.remote.conf/ then
          @nginx_remote_template = x
        end
      end
      file_list.each do |file|
        if file =~ /_\._{1}\w*/
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
        unless Dir.exists?("#{@install_path}/#{@project_name}#{x}")
          Dir.mkdir("#{@install_path}/#{@project_name}#{x}")
        end
      end
    end
    
    def create_new_files_from_whole_templates
      @whole_templates.each do |x|
        FileUtils.touch("#{@install_path}/#{@project_name}#{x}")
        file_contents = IO.readlines("#{@template_path}#{x}")
        File.open("#{@install_path}/#{@project_name}#{x}", "w") do |y|
          y.puts file_contents
        end
      end
    end
    
    # TODO Look into a way of being able to pass the 'remove last line => true' option via the naming convention of the templates
    def populate_files_from_append_templates
      @append_templates.each do |x|
        FileUtils.touch("#{@install_path}/#{@project_name}#{x.sub(/_\._{1}/, '')}")
        FileUtils.append_to_end_of_file("#{@template_path}#{x}", "#{@install_path}/#{@project_name}#{x.sub(/_\._{1}/, '')}")
      end
    end
    
    def populate_files_from_line_templates
      @line_templates.each do |x|
        FileUtils.touch("#{@install_path}/#{@project_name}#{x.sub(/_(\d+)\._{1}/, '')}")
        FileUtils.insert_text_at_line_number("#{@template_path}#{x}", "#{@install_path}/#{@project_name}#{x.sub(/_(\d+)\._{1}/, '')}", get_line_number(x))
      end
    end
    
    def remove_unwanted_files
      FileUtils.remove_files("#{@install_path}/#{@project_name}", @config_file[:remove_files])
    end
    
    def run_scripts_from_yaml(script_name)
      Dir.chdir("#{@install_path}/#{@project_name}")
      @config_file[script_name].each do |x|
        puts "Executing command: #{x}"
        system "#{x}"
      end
    end
    
    # TODO Look at the possibility of passing an nginx_config option via template naming.
    
    def get_line_number(file_name)
      /_(?<number>\d+)\._\w*/ =~ file_name
      number.to_i
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
    
  end
end