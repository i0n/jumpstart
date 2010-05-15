require 'helper'

class TestJumpstartFileUtils < Test::Unit::TestCase
      
  context "Testing JumpStart::FileUtils.append_after_line class method" do
    
    setup do
      new_file = []
      @append_after_line_test_file =
      IO.readlines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt").each do |line|
        if line !~ /Inserted by append_after_line method test./
          new_file << line
        end
      end
      File.open("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "w") do |x|
        x.puts new_file
      end
    end
    
    should "insert specified line at line number 4 of target file" do
      FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "Line from check_source_type.txt. Line number: 3", "Inserted by append_after_line method test.")
      file = IO.readlines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt")
      assert_equal(4, (file.find_index("Inserted by append_after_line method test.\n").to_i + 1))
    end
        
    should "fail because new line is not specified." do
      assert_raises(ArgumentError) {FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "Line from check_source_type.txt. Line number: 3")}
    end
    
    should "fail because the target file does not exist" do
      assert_raises(Errno::ENOENT) {FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/this_file_does_not_exist.txt", "Line from check_source_type.txt. Line number: 3", "Inserted by append_after_line method test.")}
    end
    
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