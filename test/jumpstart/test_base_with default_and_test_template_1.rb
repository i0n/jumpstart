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
  
  context "Testing jumpstart projects with a DEFAULT_TEMPLATE_NAME and JUMPSTART_TEMPLATES_PATH specified." do
        
    setup do
      clean_destination_dir
    end
        
    context "Create jumpstart with no arguments but do not start" do

      setup do
        @test_project = JumpStart::Base.new([])
      end

      should "be able to create a new jumpstart with no arguments" do
        refute_nil(@test_project)
      end

    end

    context "Create jumpstart with the project name argument passed to it but do not start" do

      setup do
        @test_project = JumpStart::Base.new(["test_jumpstart_project"])
        @test_project.install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end

      should "be able to create a new jumpstart with the project name as the first argument" do
        refute_nil(@test_project)
      end

      should "have set @project_name variable to 'test_jumpstart_project'" do
        assert_equal("test_jumpstart_project", @test_project.project_name)
      end
      
      should "have set @template_name variable to 'test_template_1'" do
        assert_equal("test_template_1", @test_project.template_name)
      end
      
      should "have set @install_path to 'ROOT_PATH/test/destination_dir'" do
        assert_equal("#{JumpStart::ROOT_PATH}/test/destination_dir", @test_project.install_path)
      end
      
      should "generate a test project in ROOT_PATH/test/destination_dir/test_jumpstart_project with the test_template_1 template" do
        @test_project.start
        assert(Dir.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_without_extension"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_without_extension"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_without_extension"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_without_extension"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_without_extension"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_whole_file_with_extension.txt"))
        assert(File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_whole_file_without_extension"))
      end

    end
    
  end
  
end
