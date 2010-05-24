require 'helper'

class TestJumpstartBase < Test::Unit::TestCase
        
  context "Testing JumpStart::Base with a @default_template_name and @jumpstart_templates_path specified.\n" do
    
    setup do
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
      @test_project = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project.instance_eval do
        @jumpstart_templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates" 
        @default_template_name = "test_template_1"
        @template_name = "test_template_1"
        @template_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1"
        set_config_file_options
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
    end
    
    teardown do
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
    end
    
    context "Tests for the JumpStart::Base#intialize instance method. \n" do
      
      should "run intialize method and set instance variables" do
        assert_equal "test_jumpstart_project", @test_project.instance_eval {@project_name}
        assert_equal "test_template_1", @test_project.instance_eval {@template_name}
        assert_equal YAML.load_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/#{@test_project.instance_eval {@template_name}}/jumpstart_config/#{@test_project.instance_eval {@template_name}}.yml"), @test_project.instance_eval {@config_file}
        assert_equal "#{JumpStart::ROOT_PATH}/test/destination_dir", @test_project.instance_eval {@install_path}
        assert_equal "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1", @test_project.instance_eval {@template_path}
      end
      
    end
    
    context "Tests for the JumpStart::Base#lookup_existing_projects instance method. \n" do
      
      should "run lookup_existing_projects method and return an array of existing templates" do
        @test_project.lookup_existing_templates
        assert_equal %w[test_template_1 test_template_2 test_template_3], @test_project.instance_eval {@existing_templates}
      end
      
    end
    
    context "Tests for the JumpStart::Base#check_project_name instance method. \n" do
      
      context "when the project name is over three characters" do
        
        should "return the project name unchanged and without errors" do
          assert_equal @test_project.instance_eval {@project_name}, @test_project.instance_eval {check_project_name}
        end
        
      end
      
      context "when the project name is not empty but is not more than 3 characters" do
        
        setup do
          input = StringIO.new("testo\n")
          output = StringIO.new
          @test_project = JumpStart::Base.new(["tr"])
          @test_project.instance_eval do
            @input = input
            @output = output
            @jumpstart_templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
            @default_template_name = "test_template_1"
            @template_name = "test_template_1"
            set_config_file_options
            @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
          end
        end
        
        should "read input from STDIN" do
          assert_equal "testo\n", @test_project.input.string
        end
        
        should "ask the user to provide a longer project name" do
          @test_project.instance_eval {check_project_name}
          assert_equal "\e[31m\nThe name of your project must be at least 3 characters long. Please enter a valid name.\e[0m\n" , @test_project.output.string
        end
        
        should "ask the user to provide a longer project name and then return the name of the project when a name longer than three characters is provided" do
          @test_project.instance_eval {check_project_name}
          assert_equal "\e[31m\nThe name of your project must be at least 3 characters long. Please enter a valid name.\e[0m\n" , @test_project.output.string
          assert_equal "testo", @test_project.instance_eval {check_project_name}
        end
                                
      end
      
      context "when the project name is empty or nil" do
        
        setup do
          input = StringIO.new("testorama\n")
          output = StringIO.new
          @test_project = JumpStart::Base.new([nil])
          @test_project.instance_eval do
            @input = input
            @output = output
            @jumpstart_templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
            @default_template_name = "test_template_1"
            @template_name = "test_template_1"
            set_config_file_options
            @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
          end
        end
        
        should "ask the user to specify a name for the project if @project_name is empty or nil" do
          @test_project.instance_eval {check_project_name}
          assert_equal "\e[1m\e[33m\nEnter a name for your project.\e[0m\n", @test_project.output.string
        end
        
        should "ask the user to specify a name for the project if @project_name is empty or nil and then set it when a name of at least 3 characters is provided" do
          @test_project.instance_eval {check_project_name}
          assert_equal "\e[1m\e[33m\nEnter a name for your project.\e[0m\n", @test_project.output.string
          assert_equal "testorama", @test_project.instance_eval {check_project_name}
        end
        
      end      
            
    end
      
    context "Tests for the JumpStart::Base#check_template_name instance method. \n" do
      
      should "run check_template_name method" do
      
      end
      
    end
    
    context "Tests for the JumpStart::Base#create_template instance method. \n" do
      
      should "run create_template method" do
      
      end
      
    end
      
    context "Tests for the JumpStart::Base#jumpstart_options instance method. \n" do
      
      should "run jumpstart_options method" do
      
      end    
      
    end
      
    context "Tests for the JumpStart::Base#configure_jumpstart instance method. \n" do
      
      should "run configure_jumpstart method" do
      
      end
      
    end
      
    context "Tests for the JumpStart::Base#check_install_paths instance method. \n" do
      
      should "run check_install_paths method" do
      
      end        
      
    end
      
    context "Tests for the JumpStart::Base#create_project method instance method. \n" do
      
      should "run create_project method" do
      
      end
      
    end
      
    context "Tests for the JumpStart::Base#parse_template_dir instance method. \n" do
      
      should "run parse_template_dir method" do
      
      end
      
    end
            
    context "Tests for the JumpStart::Base#populate_files_from_append_templates instance method. \n" do
      
      should "run populate_files_from_append_templates method" do
      
      end
      
    end
      
      
    context "Tests for the JumpStart::Base#populate_files_from_line_templates instance method. \n" do
      
      should "run populate_files_from_line_templates method" do
      
      end
      
    end
    
    context "Tests for the JumpStart::Base#check_local_nginx_configuration instance method. \n" do
      
      should "run check_local_nginx_configuration method" do
      
      end
      
    end
    
    context "Tests for the JumpStart::Base#remove_unwanted_files instance method. \n" do
      
      setup do
        @test_project.instance_eval {@project_name = "test_remove"}
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove")
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove/test_remove_files")
      end
      
      should "run remove_unwanted_files method, remove files and return true." do
        
        ["/file_with_extension.txt", "/file_without_extension"].each do |x| 
          FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove/test_remove_files#{x}")
        end
        assert @test_project.instance_eval {remove_unwanted_files}
      end
            
    end
            
    context "Tests for the JumpStart::Base#run_scripts_from_yaml instance method.\n" do
             
       should "run run_scripts_from_yaml method with the contents of :run_after_install_command symbol from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml Should be nil because the install directory does not exist." do
         assert_nil @test_project.instance_eval {run_scripts_from_yaml(:run_after_install_command)}
       end
       
       should "run the :run_after_install_command symbols scripts from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml. Should work this time as I will create the directory for the script beforehand." do
         Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
         assert_equal ["echo \"run after install command\""], @test_project.instance_eval {run_scripts_from_yaml(:run_after_install_command)}
       end
       
       should "run run_scripts_from_yaml method with the contents of :run_after_jumpstart symbol from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml Should be nil because the install directory does not exist." do
         assert_nil @test_project.instance_eval {run_scripts_from_yaml(:run_after_jumpstart)}
       end
       
       should "run the :run_after_jumpstart symbols scripts from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml. Should work this time as I will create the directory for the script beforehand." do
         Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
         assert_equal ["echo \"run after jumpstart 1st command!\"","echo \"run after jumpstart 2nd command!\""], @test_project.instance_eval {run_scripts_from_yaml(:run_after_jumpstart)}
       end
       
       should "return nil if a symbol that is not specified in YAML is passed as an argument and the install directory does not exist" do
         assert_nil @test_project.instance_eval {run_scripts_from_yaml(:this_section_does_not_exist)}
       end
       
       should "return nil if a symbol that is not specified in the YAML is passed as an argument and the install directory has been created" do
         Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
         assert_nil @test_project.instance_eval {run_scripts_from_yaml(:this_section_does_not_exist)}
       end
               
     end
    
    context "Tests for the JumpStart::#check_for_strings_to_replace instance method.\n" do
      
      setup do
        output = StringIO.new
        @test_project.instance_eval {@output = output}
      end
      
      should "return true if @replace_strings array contains hash data that is formatted correctly" do
        FileUtils.mkdir_p(FileUtils.join_paths(JumpStart::ROOT_PATH, "test/destination_dir/test_jumpstart_project/test"))
        FileUtils.touch(FileUtils.join_paths(JumpStart::ROOT_PATH, "test/destination_dir/test_jumpstart_project/test/replace_strings.txt"))
        @test_project.instance_eval {@replace_strings = [{:target_path => "/test/replace_strings.txt", :symbols => {:jam => "strawberry", :city => "london"}}]}
        assert(@test_project.instance_eval {check_for_strings_to_replace})
      end
      
      should "output message if data formatted correctly" do
        FileUtils.mkdir_p(FileUtils.join_paths(JumpStart::ROOT_PATH, "test/destination_dir/test_jumpstart_project/test"))
        FileUtils.touch(FileUtils.join_paths(JumpStart::ROOT_PATH, "test/destination_dir/test_jumpstart_project/test/replace_strings.txt"))
        @test_project.instance_eval {@replace_strings = [{:target_path => "/test/replace_strings.txt", :symbols => {:jam => "strawberry", :city => "london"}}]}
        @test_project.instance_eval {check_for_strings_to_replace}
        assert_equal("\nChecking for strings to replace inside files...\n\nTarget file: \e[32m/test/replace_strings.txt\e[0m\nStrings to replace:\n\nKey:    \e[32mjam\e[0m\nValue:  \e[32mstrawberry\e[0m\n\nKey:    \e[32mcity\e[0m\nValue:  \e[32mlondon\e[0m\n\n\n", @test_project.output.string)
      end
      
      should "return false if @replace_strings is empty." do
        @test_project.instance_eval {@replace_strings = []}
        refute(@test_project.instance_eval {check_for_strings_to_replace})
      end
      
    end
      
    context "Tests for the JumpStart::#check_replace_string_pairs_for_project_name_sub instance method.\n" do
      
      should "find :project_name symbol and return @project_name" do
        @values = {:project_name => "some_random_name"}
        @test_project.check_replace_string_pairs_for_project_name_sub(@values)
        assert_equal "test_jumpstart_project", @values[:project_name]
      end
      
      should "change values hash as it contains :project_name symbol" do
        @values = {:project_name => "some_random_name"}
        assert_equal({:project_name => "test_jumpstart_project"}, @test_project.check_replace_string_pairs_for_project_name_sub(@values))
      end
      
      should "treat all other symbols normally and not replace anything" do
        @values = {:womble => "uncle_bulgaria", :jam => "strawberry", :city => "london"}
        @test_project.check_replace_string_pairs_for_project_name_sub(@values)
        assert_equal "uncle_bulgaria", @values[:womble]
        assert_equal "strawberry", @values[:jam]
        assert_equal "london", @values[:city]
      end
      
      should "find :project_name symbol even if it is mixed with other symbols which should return unchanged" do
        @values = {:womble => "uncle_bulgaria", :jam => "strawberry", :project_name => "some_random_name", :city => "london"}
        @test_project.check_replace_string_pairs_for_project_name_sub(@values)
        assert_equal "uncle_bulgaria", @values[:womble]
        assert_equal "strawberry", @values[:jam]
        assert_equal "london", @values[:city]
        assert_equal "test_jumpstart_project", @values[:project_name]
      end
      
      should "return hash even if it is empty" do
        @values = {}
        assert_equal @values, @test_project.check_replace_string_pairs_for_project_name_sub(@values)
      end
      
    end
        
    context "Tests for the JumpStart::Base.get_line_number class method.\n" do
      
      should "return line number as 1" do
        assert_equal 1, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_1._test_file1.txt")
      end
      
      should "return line number as 10" do
        assert_equal 10, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_10._test_file2.txt")
      end
      
      should "return line number as 99999" do
        assert_equal 99999, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_99999._test_file3.txt")
      end
      
      should "return line number as false" do
        assert_equal false, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file")
        assert_equal false, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_._test_file.txt")
        assert_equal false, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file5.txt")
        assert_equal false, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file_.6txt")
        assert_equal false, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_a._test_file4.txt")
      end
        
    end
    
    context "Tests for the JumpStart::Base.remove_last_line? class method.\n" do
            
      should "return false" do
        refute JumpStart::Base.remove_last_line?("/path/to/file.txt")
        refute JumpStart::Base.remove_last_line?("/path/to/_._file.txt")
        refute JumpStart::Base.remove_last_line?("_.__file.txt")
        refute JumpStart::Base.remove_last_line?("/path/to/_R._file.txt")
        refute JumpStart::Base.remove_last_line?("/path/to/_.1_file.txt")
        refute JumpStart::Base.remove_last_line?("/path/to/_1._file.txt")
        refute JumpStart::Base.remove_last_line?("/path/to/_111._file.txt")
      end
      
      should "return true" do
        assert JumpStart::Base.remove_last_line?("/path/to/_L._file.txt")
        assert JumpStart::Base.remove_last_line?("_L._file.txt")
        assert JumpStart::Base.remove_last_line?("/path/to/_l._file.txt")
        assert JumpStart::Base.remove_last_line?("_l._file.txt")
      end
      
    end 
     
    context "Tests for initializing and running JumpStart instances\n" do
     
      context "Create jumpstart with the project name argument passed to it but do not start.\n" do
        
        should "be able to create a new jumpstart with the project name as the first argument" do
          refute_nil @test_project
        end
            
        should "have set @project_name variable to 'test_jumpstart_project'" do
          assert_equal "test_jumpstart_project", @test_project.instance_eval {@project_name}
        end
            
        should "have set @template_name variable to 'test_template_1'" do
          assert_equal "test_template_1", @test_project.instance_eval {@template_name}
        end
            
        should "have set @install_path to 'ROOT_PATH/test/destination_dir'" do
          assert_equal "#{JumpStart::ROOT_PATH}/test/destination_dir", @test_project.instance_eval {@install_path}
        end
    
        should "generate a test project in ROOT_PATH/test/destination_dir/test_jumpstart_project with the test_template_1 template" do
          @test_project.start
          assert Dir.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_whole_file_with_extension.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_whole_file_without_extension")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_replace_strings/replace_strings_1.rb")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_replace_strings/replace_strings_2.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_1.txt")
          refute File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_L._test_append_to_end_of_file_remove_last_line_1.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
          refute File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_l._test_append_to_end_of_file_remove_last_line_2.txt")
        end
            
        should "remove last lines from files and append template info" do
          @test_project.start
          file_1 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_1.txt")
          file_2 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
          assert_equal "THIS IS THE LAST LINE\n", file_1[9]
          assert_equal "THIS IS THE LAST LINE\n", file_2[9]
          assert_equal "9\n", file_1[8]
          assert_equal "9\n", file_2[8]
          refute file_1[10]
          refute file_2[10]
        end
      
      end
      
    end
                 
  end
end