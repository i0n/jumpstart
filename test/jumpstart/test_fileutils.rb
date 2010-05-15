require 'helper'

class TestJumpstartFileUtils < Test::Unit::TestCase
      
  context "Testing JumpStart::FileUtils.append_after_line class method" do
    
    setup do
      FileUtils.remove_lines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "Inserted by append_after_line method test.")
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
    
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_test.txt"
      FileUtils.remove_lines(@file_path, "TEST LINE INSERTED")
      FileUtils.remove_lines(@file_path, "TEST LINE INSERTED FROM FILE")
    end
    
    should "add the string passed in the method call to the specified file" do
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path)
      file = IO.readlines(@file_path)
      assert_equal(6, (file.find_index("TEST LINE INSERTED\n").to_i + 1))
    end

    should "add the string passed in the method call to the specified file and remove the last line" do
      # Two appended lines so that the file doesn't lose all lines over time.
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path)
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path, true)
      file = IO.readlines(@file_path)
      assert_equal("TEST LINE INSERTED\n", file.last)
      assert_equal(6, file.count)
    end
    
    should "add the contents of the file passed in the method call to the specified file" do
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path)
      file = IO.readlines(@file_path)
      assert_equal(6, (file.find_index("TEST LINE INSERTED FROM FILE\n").to_i + 1))
    end

    should "add the contents of the file passed in the method call to the specified file and remove the last line" do
      # Two appended lines so that the file doesn't lose all lines over time.
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path)
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path, true)
      file = IO.readlines(@file_path)
      assert_equal("TEST LINE INSERTED FROM FILE\n", file.last)
      assert_equal(6, file.count)
    end
    
    should "fail because no target file is specified" do
      assert_raises(ArgumentError) {FileUtils.append_to_end_of_file("TEST LINE INSERTED")}
    end
    
    should "fail because target file does not exist" do
      assert_raises(Errno::ENOENT) {FileUtils.append_to_end_of_file("TEST LINE INSERTED", "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/does_not_exist/file.txt")}
    end
        
  end

  context "Testing JumpStart::FileUtils.insert_text_at_line_number class method" do
    
  end

  context "Testing JumpStart::FileUtils.remove_files class method" do
    
  end
  
  context "Testing JumpStart::FileUtils.remove_lines class method" do
    
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