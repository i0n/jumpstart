require 'helper'

# SET CONSTANTS FOR TESTING
module JumpStart
  DEFAULT_TEMPLATE_NAME = "test_template_1"
  JUMPSTART_TEMPLATES_PATH = "#{ROOT_PATH}/test/test_jumpstart_templates"
end

class TestJumpstartBase < Test::Unit::TestCase
  
  def clean_destination_dir
    generated_test_files = Find.find("#{JumpStart::ROOT_PATH}/test/destination_dir")
    generated_test_files.each do |x|
      if File.file?(x)
        FileUtils.rm(x)
      elsif File.directory?(x) && x != "#{JumpStart::ROOT_PATH}/test/destination_dir"
        FileUtils.remove_dir(x)
      end
    end
  end
  
  context "Testing JumpStart::Base methods with a DEFAULT_TEMPLATE_NAME and JUMPSTART_TEMPLATES_PATH specified." do
    
    setup do
      @test_project = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project.install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
    end
        
    should "run intialize method" do
      
    end
    
    should "run start method" do
      
    end
      
    should "run lookup_existing_projects method" do
      
    end
    
    should "run check_project_name method" do
      
    end
    
    should "run check_template_name method" do
      
    end
    
    should "run jumpstart_options method" do
      
    end
    
    should "run configure_jumpstart method" do
      
    end
    
    should "run check_install_paths method" do
      
    end
    
    should "run create_project method" do
      
    end
        
    should "run parse_template_dir method" do
      
    end
    
    should "run create_new_folders method" do
      
    end
        
    should "run create_new_files_from_whole_templates method" do
      
    end
    
    should "run populate_files_from_append_templates method" do
      
    end
    
    should "run populate_files_from_line_templates method" do
      
    end
    
    should "run check_local_nginx_configuration method" do
      
    end
    
    should "run remove_unwanted_files method" do
      
    end
    
    should "run run_scripts_from_yaml method" do
      
    end
        
    context "Tests for the JumpStart::Base.get_line_number class method" do
      
      should "line number should be 1" do
        assert_equal(1, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_1._test_file1.txt"))
      end
      
      should "line number should be 10" do
        assert_equal(10, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_10._test_file2.txt"))
      end
      
      should "line number should be 99999" do
        assert_equal(99999, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_99999._test_file3.txt"))
      end
      
      should "line number should be 0" do
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_._test_file.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_._test_file_.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file5.txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/test_file_.6txt"))
        assert_equal(0, JumpStart::Base.get_line_number("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_base/_a._test_file4.txt"))
      end
        
    end
    
    # should "run exit_jumpstart method" do
    #   assert_equal(1, @test_project.exit_jumpstart)
    # end
     
  end
  
end