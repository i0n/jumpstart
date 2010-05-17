require 'helper'

# SET CONSTANTS FOR TESTING
module JumpStart
  DEFAULT_TEMPLATE_NAME = "test_template_1"
  JUMPSTART_TEMPLATES_PATH = "#{ROOT_PATH}/test/test_jumpstart_templates"
end

class TestJumpstartBase < Test::Unit::TestCase
    
  context "Testing JumpStart::Base methods with a DEFAULT_TEMPLATE_NAME and JUMPSTART_TEMPLATES_PATH specified.\n" do
    
    setup do
      @test_project = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project.install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
    end    
    
    context "Tests for the JumpStart::Base#intialize instance method. \n" do
      
      should "run intialize method" do

      end
      
    end

    context "Tests for the JumpStart::Base#start instance method. \n" do
      
      should "run start method" do

      end    
      
    end

    context "Tests for the JumpStart::Base#lookup_existing_projects instance method. \n" do
      
      should "run lookup_existing_projects method" do

      end
      
    end

    context "Tests for the JumpStart::Base#check_project_name instance method. \n" do
      
      should "run check_project_name method" do

      end
      
    end

    context "Tests for the JumpStart::Base#check_template_name instance method. \n" do
      
      should "run check_template_name method" do

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
        
    context "Tests for the JumpStart::Base#create_new_folders instance method. \n" do
      
      should "run create_new_folders method" do

      end    
      
    end

    context "Tests for the JumpStart::Base#create_new_files_from_whole_templates instance method. \n" do
      
      should "run create_new_files_from_whole_templates method" do

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
    
    # TODO Add tests that involve extended FileUtils methods after writing tests for FileUtils module.
    context "Tests for the JumpStart::Base#check_local_nginx_configuration instance method. \n" do
      
      should "run check_local_nginx_configuration method" do

      end
      
    end
    
    context "Tests for the JumpStart::Base#remove_unwanted_files instance method. \n" do

      setup do
        clean_destination_dir
        @test_project.project_name = "test_remove"
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove")
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove/test_remove_files")
      end

      should "run remove_unwanted_files method, remove files and return true." do
        
        ["/file_with_extension.txt", "/file_without_extension"].each do |x| 
          FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/test_remove/test_remove_files#{x}")
        end
        assert(@test_project.remove_unwanted_files)
      end
            
    end
            
    context "Tests for the JumpStart::Base#run_scripts_from_yaml instance method.\n" do
      
      setup do
        clean_destination_dir
      end
      
      should "run run_scripts_from_yaml method with the contents of :run_after_install_command symbol from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml Should be nil because the install directory does not exist." do
        assert_nil(@test_project.run_scripts_from_yaml(:run_after_install_command))
      end
      
      should "run the :run_after_install_command symbols scripts from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml. Should work this time as I will create the directory for the script beforehand." do
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
        assert_equal(["echo \"run after install command\""], @test_project.run_scripts_from_yaml(:run_after_install_command))
      end
      
      should "run run_scripts_from_yaml method with the contents of :run_after_jumpstart symbol from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml Should be nil because the install directory does not exist." do
        assert_nil(@test_project.run_scripts_from_yaml(:run_after_jumpstart))
      end
      
      should "run the :run_after_jumpstart symbols scripts from ROOT_PATH/test/test_template_1/jumpstart_config/test_template_1.yml. Should work this time as I will create the directory for the script beforehand." do
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
        assert_equal(["echo \"run after jumpstart 1st command!\"","echo \"run after jumpstart 2nd command!\""], @test_project.run_scripts_from_yaml(:run_after_jumpstart))
      end
      
      should "return nil if a symbol that is not specified in YAML is passed as an argument and the install directory does not exist" do
        assert_nil(@test_project.run_scripts_from_yaml(:this_section_does_not_exist))
      end
      
      should "return nil if a symbol that is not specified in the YAML is passed as an argument and the install directory has been created" do
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
        assert_nil(@test_project.run_scripts_from_yaml(:this_section_does_not_exist))
      end
        
    end
        
    context "Tests for the JumpStart::Base.get_line_number class method.\n" do
      
      should "return line number as 1" do
        assert_equal(1, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_1._test_file1.txt"))
      end
      
      should "return line number as 10" do
        assert_equal(10, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_10._test_file2.txt"))
      end
      
      should "return line number as 99999" do
        assert_equal(99999, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_99999._test_file3.txt"))
      end
      
      should "return line number as 0" do
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_._test_file.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_._test_file_.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file5.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file_.6txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_a._test_file4.txt"))
      end
        
    end
    
    context "Tests for the JumpStart::Base.remove_last_line? class method.\n" do
            
      should "return false" do
        refute(JumpStart::Base.remove_last_line?("/path/to/file.txt"))
        refute(JumpStart::Base.remove_last_line?("/path/to/_._file.txt"))
        refute(JumpStart::Base.remove_last_line?("_.__file.txt"))
        refute(JumpStart::Base.remove_last_line?("/path/to/_R._file.txt"))
        refute(JumpStart::Base.remove_last_line?("/path/to/_.1_file.txt"))
        refute(JumpStart::Base.remove_last_line?("/path/to/_1._file.txt"))
        refute(JumpStart::Base.remove_last_line?("/path/to/_111._file.txt"))
      end
      
      should "return true" do
        assert(JumpStart::Base.remove_last_line?("/path/to/_L._file.txt"))
        assert(JumpStart::Base.remove_last_line?("_L._file.txt"))
        assert(JumpStart::Base.remove_last_line?("/path/to/_l._file.txt"))
        assert(JumpStart::Base.remove_last_line?("_l._file.txt"))
      end
      
    end
         
  end
  
end