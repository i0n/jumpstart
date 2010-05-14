require 'helper'

class TestJumpstartFileUtils < Test::Unit::TestCase
  
  context "Testing JumpStart::FileUtils class methods.\n" do
    
    context "Testing JumpStart::FileUtils.append_after_line class method" do
      
    end

    context "Testing JumpStart::FileUtils.append_to_end_of_file class method" do
      
    end

    context "Testing JumpStart::FileUtils.insert_text_at_line_number class method" do
      
    end

    context "Testing JumpStart::FileUtils.remove_files class method" do
      
    end

    context "Testing JumpStart::FileUtils.config_nginx class method" do
      
    end

    context "Testing JumpStart::FileUtils.config_etc_hosts class method" do
      
    end

    # TODO Come back to testing this method when I have looked at Capistrano template creation and value replacement.
    context "Testing JumpStart::FileUtils.config_capistrano class method" do
      
    end

    # TODO Come back to testing this method when I have had a look at it's functionality.
    context "Testing JumpStart::FileUtils.make_bare_git_repo class method" do
      
    end

    context "Testing JumpStart::FileUtils.check_source_type class method" do
      
      should "return source as a string" do
        assert_equal("source_as_a_string", FileUtils.check_source_type("source_as_a_string"))
      end
      
      should "return source as an array" do
        assert_equal(["Line from check_source_type.txt. Line number: 1\n",
         "Line from check_source_type.txt. Line number: 2\n",
         "Line from check_source_type.txt. Line number: 3\n",
         "Line from check_source_type.txt. Line number: 4\n",
         "Line from check_source_type.txt. Line number: 5\n",
         "Line from check_source_type.txt. Line number: 6\n",
         "Line from check_source_type.txt. Line number: 7\n",
         "Line from check_source_type.txt. Line number: 8\n",
         "Line from check_source_type.txt. Line number: 9\n",
         "Line from check_source_type.txt. Line number: 10"], FileUtils.check_source_type("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/check_source_type.txt"))
      end
      
      should "return source as an array, even without a file extension." do
        assert_equal(["Line from check_source_type.txt. Line number: 1\n",
         "Line from check_source_type.txt. Line number: 2\n",
         "Line from check_source_type.txt. Line number: 3\n",
         "Line from check_source_type.txt. Line number: 4\n",
         "Line from check_source_type.txt. Line number: 5"], FileUtils.check_source_type("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/check_source_type"))
      end
      
    end
    
  end
  
end