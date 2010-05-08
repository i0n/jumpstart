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
      create_new_folders
      create_new_files_from_whole_templates
      populate_files_from_append_templates
      populate_files_from_line_templates
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
      if @existing_projects.include? @project_name
        
      else
        puts "A JumpStart project of that name doesn't exist would you like to create it?"
      end
    end
    
    def load_config_options
      @config_file = YAML.load_file("#{JUMPSTART_TEMPLATES_PATH}/#{@project_name}/jumpstart_config/#{@project_name}.yml")
    end
    
    def check_install_paths
      @install_path = @config_file[:install_path]
      @template_path = "#{JUMPSTART_TEMPLATES_PATH}/#{@project_name}"
      [@install_path, @template_path].each do |x|
        begin
          Dir.chdir(x)
        rescue
          puts "The directory #{x} could not be found, or you do not have the correct permissions to access it."
        end
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
        when File.file?(x) then
          file_list << x.sub!(@template_path, '')
        when File.directory?(x) then
          @dir_list << x.sub!(@template_path, '')
        end
      end
      file_list.each do |file|
        if file =~ /_\._{1}\w*/
          @append_templates << file
        elsif file =~ /_\d\._{1}\w*/
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
    
    def populate_files_from_append_templates
      @append_templates.each do |x|
        FileUtils.touch("#{@install_path}/#{@project_name}#{x.sub(/_\._{1}/, '')}")
        FileUtils.append_to_end_of_file("#{@template_path}#{x}", "#{@install_path}/#{@project_name}#{x.sub(/_\._{1}/, '')}")
      end
    end
    
    def populate_files_from_line_templates
      @line_templates.each do |x|
        FileUtils.touch("#{@install_path}/#{@project_name}#{x.sub(/_\d\._{1}/, '')}")
        FileUtils.insert_text_at_line_number("#{@template_path}#{x}", "#{@install_path}/#{@project_name}#{x.sub(/_\d\._{1}/, '')}", get_line_number(x))
      end
    end
    
    private
    
    def get_line_number(file_name)
      /_(?<number>\d)\._{1}\w*/ =~ file_name
      number.to_i
    end
    
  end
end