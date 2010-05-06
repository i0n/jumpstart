module JumpStart
  class Base

    def initialize(project_name)
      @project_name = project_name      
      @existing_projects = []
    end
    
    def start
      lookup_existing_projects
      check_project_name
      load_config_options
      check_install_paths
      create_project
      parse_template_dir
      create_new_files
    end
    
    private
    
    def lookup_existing_projects
      Dir.entries("#{CONFIG_PATH}/templates").each do |x| 
        x.gsub!('.yml', '')
        if x.length > 2
          @existing_projects << x
        end
      end
    end
    
    def check_project_name
      if @existing_projects.include? @project_name
        
      else
        puts "A JumpStart project of that name doesn't exist would you like to create it?"
      end
    end
    
    def load_config_options
      @config_file = YAML.load_file("#{CONFIG_PATH}/templates/#{@project_name}.yml")
    end
    
    def check_install_paths
      @install_path = @config_file[:install_path]
      @template_path = @config_file[:template_path]
      [@install_path, @template_path].each do |x|
        begin
          Dir.chdir(x)
        rescue
          puts "The directory #{x} could not be found."
        end
      end
    end
        
    def create_project
      @install_command = @config_file[:install_command]
      @install_command_options = @config_file[:install_command_options]
      Dir.chdir(@install_path)
      puts "Executing command: #{@install_command} #{@project_name} #{@install_command_options}"
      `#{@install_command} #{@project_name} #{@install_command_options}`
    end
    
    def parse_template_dir
      @dir_list = []
      @file_list = []
      Find.find(@template_path) do |x|
        case
        when File.file?(x) then
          @file_list << x.sub!(@template_path, '')
        when File.directory?(x) then
          @dir_list << x.sub!(@template_path, '')
        end
      end
      puts "Dirs"
      puts @dir_list
      puts ""
      puts "Files"
      puts @file_list
    end
    
    def create_new_files
      @file_list.each do |x|
        FileUtils.touch("#{@install_path}#{@project_name}#{x}")
      end
    end
    
  end
end