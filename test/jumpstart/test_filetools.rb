require 'helper'

class TestJumpstartFileTools < Test::Unit::TestCase
      
  context "Testing JumpStart::FileUtils.append_after_line class method" do
    
    setup do
      FileUtils.remove_lines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", :pattern => "Inserted by append_after_line method test.")
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
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED")
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED FROM FILE")
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

    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/insert_text_at_line_number_test.txt"
      @source_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/insert_text_at_line_number_source.txt"
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED")
    end
    
    should "insert text from string into target file at line 3" do
      FileUtils.insert_text_at_line_number("TEST LINE INSERTED", @file_path, 3)
      file = IO.readlines(@file_path)
      assert_equal("TEST LINE INSERTED\n", file[2])
      assert_equal(5, file.count)
    end
    
    should "insert text from source file into target file at line 2" do
      FileUtils.insert_text_at_line_number(@source_path, @file_path, 2)
      file = IO.readlines(@file_path)
      assert_equal("TEST LINE INSERTED FROM FILE\n", file[1])
      assert_equal(5, file.count)
    end
    
    should "raise an exception if a line number is not passed to the method" do
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path)}
    end
    
    should "raise an exception if the line number is not 1 or higher" do
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path, 0)}
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path, -10)}
    end

  end

  context "Testing JumpStart::FileUtils.remove_files class method" do
  
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils"
      FileUtils.touch("#{@file_path}/remove_files_test_1.txt")
      FileUtils.touch("#{@file_path}/remove_files_test_2.txt")
      FileUtils.touch("#{@file_path}/remove_files_test_3.txt")
    end
  
    should "delete the file remove_files_test_1.txt" do
      FileUtils.remove_files(@file_path, ["/remove_files_test_1.txt"])
      refute(File.exists?("#{@file_path}/remove_files_test_1.txt"))
    end
    
    should "delete all three test files" do
      FileUtils.remove_files(@file_path, ["/remove_files_test_1.txt", "/remove_files_test_2.txt", "/remove_files_test_3.txt"])
      refute(File.exists?("#{@file_path}/remove_files_test_1.txt"))
      refute(File.exists?("#{@file_path}/remove_files_test_2.txt"))
      refute(File.exists?("#{@file_path}/remove_files_test_3.txt"))
    end
    
    should "delete all three files even though some of the paths have too many forward slashes" do
      FileUtils.remove_files("#{@file_path}/", ["/remove_files_test_1.txt", "remove_files_test_2.txt", "/remove_files_test_3.txt"])
      refute(File.exists?("#{@file_path}/remove_files_test_1.txt"))
      refute(File.exists?("#{@file_path}/remove_files_test_2.txt"))
      refute(File.exists?("#{@file_path}/remove_files_test_3.txt"))      
    end
  
  end
  
  context "Testing JumpStart::FileUtils.remove_lines class method" do
    
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/remove_lines_test.txt"
    end
    
    should "remove line 5 from the test file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :lines => [5])
      file = IO.readlines(@file_path)
      assert_equal(9, file.length)
      assert_equal("6\n", file.fetch(4))
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
    
    should "remove lines 5 & 9 from the test file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :lines => [1,10])
      file = IO.readlines(@file_path)
      assert_equal(8, file.length)
      FileUtils.insert_text_at_line_number("1", @file_path, 1)
      FileUtils.insert_text_at_line_number("10", @file_path, 10)
    end
    
    should "remove line 5 from the test file using the :line argument" do
      FileUtils.remove_lines(@file_path, :line => 5)
      file = IO.readlines(@file_path)
      assert_equal(9, file.length)
      assert_equal("6\n", file.fetch(4))
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
    
    should "return an argument error as :lines and :line cannot be specified at the same time." do
      assert_raise(ArgumentError) {FileUtils.remove_lines(@file_path, :line => 5, :lines => [6,7])}
    end
    
    should "remove line 5 from the test file using the :pattern argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5")
      file = IO.readlines(@file_path)
      assert_equal(9, file.length)
      assert_equal("6\n", file.fetch(4))
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
    
    should "remove line 5 from the test file using the pattern argument, and remove line 9 from the file using the :line argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5", :line => 9)
      file = IO.readlines(@file_path)
      assert_equal(8, file.length)
      assert_equal("6\n", file.fetch(4))
      assert_equal("10\n", file.fetch(7))
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
      FileUtils.insert_text_at_line_number("9", @file_path, 9)
    end

    should "remove line 5 from the test file using the pattern argument, and remove line 9 from the file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5", :lines => [8,9])
      file = IO.readlines(@file_path)
      assert_equal(7, file.length)
      assert_equal("6\n", file.fetch(4))
      assert_equal("7\n", file.fetch(5))
      assert_equal("10\n", file.fetch(6))
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
      FileUtils.insert_text_at_line_number("8", @file_path, 8)
      FileUtils.insert_text_at_line_number("9", @file_path, 9)
    end
    
  end

  context "Testing JumpStart::FileUtils.config_nginx class method" do
    
    setup do
      @source_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_nginx_source.txt"
      @target_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_nginx_test.txt"
      @project_name = "test_project"
      FileUtils.remove_lines(@target_path, :pattern => "LINE ADDED BY TEST")
    end
    
    should "copy nginx source file into target path" do
      FileUtils.config_nginx(@source_path, @target_path, @project_name)
      file = IO.readlines(@target_path)
      assert_equal("LINE ADDED BY TEST\n", file[80])
    end
    
  end

  context "Testing JumpStart::FileUtils.config_hosts class method" do
    
    setup do
      @project_name = "test_project"
      @target_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/hosts_test"
      FileUtils.remove_lines(@target_path, :pattern => "127.0.0.1 test_project.local")
    end
    
    should "add line for test_project.local to hosts_test file" do
      FileUtils.config_hosts(@target_path, @project_name)
      file = IO.readlines(@target_path)
      assert_equal("127.0.0.1 test_project.local\n", file[10])
    end
    
  end

  # TODO Come back to testing this method when I have looked at Capistrano template creation and value replacement.
  context "Testing JumpStart::FileUtils.replace_strings class method" do
    
    setup do
      @target_file = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_capistrano_test.rb"
      @app_name = "test_project"
      @remote_server = "my_test_remote_server"
      @source_file = IO.readlines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_capistrano_source.rb")
      File.open(@target_file, 'w+') do |file|
        file.puts @source_file
      end
    end
        
    should "replace strings with replace_strings method" do
      FileUtils.replace_strings(@target_file, :app_name => 'test_app', :REMOTE_SERVER => 'remote_box')
      file = IO.readlines(@target_file)
      assert_equal("set :application, 'test_app'\n", file[0])
      assert_equal("set :domain, 'remote_box'\n", file[1])
      assert_equal("run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf test_app\"\n", file[44])
    end
    
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