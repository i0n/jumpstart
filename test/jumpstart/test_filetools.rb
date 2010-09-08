require 'helper'

class TestJumpstartFileTools < Test::Unit::TestCase

  context "Testing JumpStart::FileUtils#append_after_line class method.\n" do
  
    setup do
      FileUtils.remove_lines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", :pattern => "Inserted by append_after_line method test.")
    end
  
    should "insert specified line at line number 4 of target file" do
      FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "Line from check_source_type.txt. Line number: 3", "Inserted by append_after_line method test.")
      file = IO.readlines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt")
      assert_equal 4, (file.find_index("Inserted by append_after_line method test.\n").to_i + 1)
    end
  
    should "fail because new line is not specified." do
      assert_raises(ArgumentError) {FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_after_line_test.txt", "Line from check_source_type.txt. Line number: 3")}
    end
  
    should "fail because the target file does not exist" do
      assert_raises(Errno::ENOENT) {FileUtils.append_after_line("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/this_file_does_not_exist.txt", "Line from check_source_type.txt. Line number: 3", "Inserted by append_after_line method test.")}
    end
  
  end
  
  context "Testing JumpStart::FileUtils#append_to_end_of_file class method.\n" do
  
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_test.txt"
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED")
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED FROM FILE")
    end
  
    should "add the string passed in the method call to the specified file" do
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path)
      file = IO.readlines(@file_path)
      assert_equal 6, (file.find_index("TEST LINE INSERTED\n").to_i + 1)
    end
  
    should "add the string passed in the method call to the specified file and remove the last line" do
      # Two appended lines so that the file doesn't lose all lines over time.
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path)
      FileUtils.append_to_end_of_file("TEST LINE INSERTED", @file_path, true)
      file = IO.readlines(@file_path)
      assert_equal "TEST LINE INSERTED\n", file.last
      assert_equal 6, file.count
    end
  
    should "add the contents of the file passed in the method call to the specified file" do
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path)
      file = IO.readlines(@file_path)
      assert_equal 6, (file.find_index("TEST LINE INSERTED FROM FILE\n").to_i + 1)
    end
  
    should "add the contents of the file passed in the method call to the specified file and remove the last line" do
      # Two appended lines so that the file doesn't lose all lines over time.
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path)
      FileUtils.append_to_end_of_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/append_to_end_of_file_source.txt", @file_path, true)
      file = IO.readlines(@file_path)
      assert_equal "TEST LINE INSERTED FROM FILE\n", file.last
      assert_equal 6, file.count
    end
  
    should "fail because no target file is specified" do
      assert_raises(ArgumentError) {FileUtils.append_to_end_of_file("TEST LINE INSERTED")}
    end
  
    should "fail because target file does not exist" do
      assert_raises(Errno::ENOENT) {FileUtils.append_to_end_of_file("TEST LINE INSERTED", "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/does_not_exist/file.txt")}
    end
  
  end
  
  context "Testing JumpStart::FileUtils#insert_text_at_line_number class method.\n" do
  
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/insert_text_at_line_number_test.txt"
      @source_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/insert_text_at_line_number_source.txt"
      FileUtils.remove_lines(@file_path, :pattern => "TEST LINE INSERTED")
    end
  
    should "insert text from string into target file at line 3" do
      FileUtils.insert_text_at_line_number("TEST LINE INSERTED", @file_path, 3)
      file = IO.readlines(@file_path)
      assert_equal "TEST LINE INSERTED\n", file[2]
      assert_equal 5, file.count
    end
  
    should "insert text from source file into target file at line 2" do
      FileUtils.insert_text_at_line_number(@source_path, @file_path, 2)
      file = IO.readlines(@file_path)
      assert_equal "TEST LINE INSERTED FROM FILE\n", file[1]
      assert_equal 5, file.count
    end
  
    should "raise an exception if a line number is not passed to the method" do
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path)}
    end
  
    should "raise an exception if the line number is not 1 or higher" do
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path, 0)}
      assert_raises(ArgumentError) {FileUtils.insert_text_at_line_number(@source_path, @file_path, -10)}
    end
  
  end
  
  context "Testing JumpStart::FileUtils#remove_files class method.\n" do
  
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils"
      FileUtils.touch("#{@file_path}/remove_files_test_1.txt")
      FileUtils.touch("#{@file_path}/remove_files_test_2.txt")
      FileUtils.touch("#{@file_path}/remove_files_test_3.txt")
      @file_array = []
    end
  
    should "delete the file remove_files_test_1.txt" do
      file = FileUtils.join_paths(@file_path, "/remove_files_test_1.txt")
      @file_array << file
      FileUtils.remove_files(@file_array)
      assert !File.exists?("#{@file_path}/remove_files_test_1.txt")
    end
  
    should "delete all three test files" do
      @file_array  << "/remove_files_test_1.txt" << "/remove_files_test_2.txt" << "/remove_files_test_3.txt"
      @file_array.map!{|x| FileUtils.join_paths(@file_path, x)}
      FileUtils.remove_files(@file_array)
      assert !File.exists?("#{@file_path}/remove_files_test_1.txt")
      assert !File.exists?("#{@file_path}/remove_files_test_2.txt")
      assert !File.exists?("#{@file_path}/remove_files_test_3.txt")
    end
  
  end
  
  context "Testing JumpStart::FileUtils#remove_lines class method.\n" do
  
    setup do
      @file_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/remove_lines_test.txt"
    end
  
    should "remove line 5 from the test file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :lines => [5])
      file = IO.readlines(@file_path)
      assert_equal 9, file.length
      assert_equal "6\n", file.fetch(4)
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
  
    should "remove lines 5 & 9 from the test file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :lines => [1,10])
      file = IO.readlines(@file_path)
      assert_equal 8, file.length
      FileUtils.insert_text_at_line_number("1", @file_path, 1)
      FileUtils.insert_text_at_line_number("10", @file_path, 10)
    end
  
    should "remove line 5 from the test file using the :line argument" do
      FileUtils.remove_lines(@file_path, :line => 5)
      file = IO.readlines(@file_path)
      assert_equal 9, file.length
      assert_equal "6\n", file.fetch(4)
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
  
    should "return an argument error as :lines and :line cannot be specified at the same time." do
      assert_raises(ArgumentError) {FileUtils.remove_lines(@file_path, :line => 5, :lines => [6,7])}
    end
  
    should "remove line 5 from the test file using the :pattern argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5")
      file = IO.readlines(@file_path)
      assert_equal 9, file.length
      assert_equal "6\n", file.fetch(4)
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
    end
  
    should "remove line 5 from the test file using the pattern argument, and remove line 9 from the file using the :line argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5", :line => 9)
      file = IO.readlines(@file_path)
      assert_equal 8, file.length
      assert_equal "6\n", file.fetch(4)
      assert_equal "10\n", file.fetch(7)
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
      FileUtils.insert_text_at_line_number("9", @file_path, 9)
    end
  
    should "remove line 5 from the test file using the pattern argument, and remove line 9 from the file using the :lines argument" do
      FileUtils.remove_lines(@file_path, :pattern => "5", :lines => [8,9])
      file = IO.readlines(@file_path)
      assert_equal 7, file.length
      assert_equal "6\n", file.fetch(4)
      assert_equal "7\n", file.fetch(5)
      assert_equal "10\n", file.fetch(6)
      FileUtils.insert_text_at_line_number("5", @file_path, 5)
      FileUtils.insert_text_at_line_number("8", @file_path, 8)
      FileUtils.insert_text_at_line_number("9", @file_path, 9)
    end
  
  end
  
  context "Testing JumpStart::FileUtils#config_nginx class method.\n" do
  
    setup do
      @source_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_nginx_source.txt"
      @target_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_nginx_test.txt"
      @project_name = "test_project"
      FileUtils.remove_lines(@target_path, :pattern => "LINE ADDED BY TEST")
    end
  
    should "copy nginx source file into target path" do
      FileUtils.config_nginx(@source_path, @target_path, @project_name)
      file = IO.readlines(@target_path)
      assert_equal "LINE ADDED BY TEST\n", file[80]
    end
  
  end
  
  context "Testing JumpStart::FileUtils#config_hosts class method.\n" do
  
    setup do
      @project_name = "test_project"
      @target_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/hosts_test"
      FileUtils.remove_lines(@target_path, :pattern => "127.0.0.1 test_project.local")
    end
  
    should "add line for test_project.local to hosts_test file" do
      FileUtils.config_hosts(@target_path, @project_name)
      file = IO.readlines(@target_path)
      assert_equal "127.0.0.1 test_project.local\n", file[10]
    end
  
  end

  context "Testing JumpStart::FileUtils#replace_strings class method" do

    setup do
      @source_file = IO.readlines("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_capistrano_source.rb")
      @target_file_1 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/config_capistrano_test.rb"
      @target_file_2 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/replace_strings_test_app_name.rb"
      @target_file_3 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name/app_name_replace_strings_test.txt"
      @target_file_4 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name/Rakefile"
      @new_file_2 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/replace_strings_test_bungle.rb"
      @new_file_3 = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/bungle/bungle_replace_strings_test.txt"
      @target_files = [@target_file_1, @target_file_2, @target_file_3]
      FileUtils.mkdir_p("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name")
      @target_files.each do |t|
        File.open(t, 'w') do |file|
          file.puts @source_file
        end
      end
    end

    teardown do
      FileUtils.remove_files(@target_files)
      if File.exists?(@new_file_2)
        FileUtils.remove_file(@new_file_2)
      end
      if File.directory?("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/bungle")
        FileUtils.remove_dir("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/bungle")
      end
      if File.directory?("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name")
        FileUtils.remove_dir("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name")
      end
    end
    
    should "replace strings with replace_strings method if the path does not contain the replacement strings and only one replacement string is provided" do
      FileUtils.replace_strings(@target_file_1, {:app_name => 'test_app'})
      file = IO.readlines(@target_file_1)
      assert_equal "set :application, 'test_app'\n", file[0]
      assert_equal "run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf test_app\"\n", file[44]
    end
    
    should "replace strings with replace_strings method if the path does not contain the replacement strings and more than one replacement string is provided" do
      FileUtils.replace_strings(@target_file_1, {:app_name => 'test_app', :REMOTE_SERVER => 'remote_box'})
      file = IO.readlines(@target_file_1)
      assert_equal "set :application, 'test_app'\n", file[0]
      assert_equal "set :domain, 'remote_box'\n", file[1]
      assert_equal "run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf test_app\"\n", file[44]
    end

    should "replace strings inside the target path if the target is a file and there is more than one argument." do
      FileUtils.replace_strings(@target_file_2, {:app_name => 'bungle', :remote_server => 'boxy'})
      file = IO.readlines(@new_file_2)
      assert_equal "set :application, 'bungle'\n", file[0]
      assert_equal "set :domain, 'boxy'\n", file[1]
      assert_equal "run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf bungle\"\n", file[44]
      assert File.exists?(@new_file_2)
      assert !File.exists?(@target_file_2)
    end
  
    should "replace strings inside the target path if the target is a file and there is more than one argument and the replacement string is found in the directory structure." do
      FileUtils.replace_strings(@target_file_3, {:app_name => 'bungle', :remote_server => 'boxy'})
      file = IO.readlines(@new_file_3)
      assert_equal "set :application, 'bungle'\n", file[0]
      assert_equal "set :domain, 'boxy'\n", file[1]
      assert_equal "run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf bungle\"\n", file[44]
      assert File.exists?(@new_file_3)
      assert !File.exists?(@target_file_3)
    end
  
    should "replace strings that have _CLASS appended to them with a capitalised version of the replacement string." do
      FileUtils.replace_strings(@target_file_3, {:app_name => 'bungle', :remote_server => 'boxy'})
      file = IO.readlines(@new_file_3)
      assert_equal "set :application, 'bungle'\n", file[0]
      assert_equal "set :domain, 'boxy'\n", file[1]
      assert_equal "run \"\#{sudo} nginx_auto_config /usr/local/bin/nginx.remote.conf /opt/nginx/conf/nginx.conf bungle\"\n", file[44]
      assert_equal "# This is a test string Bungle\n", file[63]
      assert_equal "# This is a test string Boxy\n", file[64]
      assert File.exists?(@new_file_3)
      assert !File.exists?(@target_file_3)
    end
    
    should "remove old dirs when empty after string replacement" do
      FileUtils.replace_strings(@target_file_3, {:app_name => 'bungle', :remote_server => 'boxy'})
      assert !File.directory?("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name")
    end
    
    should "not remove old dirs after string replacement if they are not empty" do
      FileUtils.touch("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name/another_file.txt")
      FileUtils.replace_strings(@target_file_3, {:app_name => 'bungle', :remote_server => 'boxy'})
      assert File.directory?("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/app_name")
      assert File.exists?(@new_file_3)
    end
  
  end
  
  context "Testing JumpStart::FileUtils#check_source_type class method.\n" do
  
    should "return source as a string" do
      assert_equal "source_as_a_string", FileUtils.check_source_type("source_as_a_string")
    end
  
    should "return source as an array" do
      assert_equal ["Line from check_source_type.txt. Line number: 1\n",
                    "Line from check_source_type.txt. Line number: 2\n",
                    "Line from check_source_type.txt. Line number: 3\n",
                    "Line from check_source_type.txt. Line number: 4\n",
                    "Line from check_source_type.txt. Line number: 5\n",
                    "Line from check_source_type.txt. Line number: 6\n",
                    "Line from check_source_type.txt. Line number: 7\n",
                    "Line from check_source_type.txt. Line number: 8\n",
                    "Line from check_source_type.txt. Line number: 9\n",
                    "Line from check_source_type.txt. Line number: 10"], FileUtils.check_source_type("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/check_source_type.txt")
    end
  
    should "return source as an array, even without a file extension." do
      assert_equal ["Line from check_source_type.txt. Line number: 1\n",
                    "Line from check_source_type.txt. Line number: 2\n",
                    "Line from check_source_type.txt. Line number: 3\n",
                    "Line from check_source_type.txt. Line number: 4\n",
                    "Line from check_source_type.txt. Line number: 5"], FileUtils.check_source_type("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/check_source_type")
    end
  
  end
  
  context "Testing JumpStart::#join_paths class method.\n" do
  
    should "return the relative path passed to it unaltered." do
      assert_equal "path/to/file.txt", FileUtils.join_paths("path/to/file.txt")
    end
  
    should "return the absolute path passed to it unaltered." do
      assert_equal "/path/to/file.txt", FileUtils.join_paths("/path/to/file.txt")
    end
  
    should "return the path even if it is passed as a variable" do
      string = "/path/to/file.txt"
      assert_equal string, FileUtils.join_paths(string)
    end
  
    should "return a valid path if too many forward slashes are entered as an array" do
      a = %w[this/ //array/// /of/ /paths/ /has// /far/ //too/ ////many/ /forward// /slashes.txt]
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a)
    end
  
    should "return a valid path if too many forward slashes are entered as strings" do
      a,b,c,d,e,f,g,h,i,j = 'this/', '//array///', '/of/', '/paths/', '/has//', '/far/', '//too/', '////many/', '/forward//', '/slashes.txt'
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j)
    end
  
    should "return a valid path if paths are missing forward slashes and entered as an array" do
      a = %w[this array of paths has far too many forward slashes.txt]
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a)
    end
  
    should "return a valid path if paths are passed as strings and have no forward slashes" do
      a,b,c,d,e,f,g,h,i,j = 'this', 'array', 'of', 'paths', 'has', 'far', 'too', 'many', 'forward', 'slashes.txt'
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j)
    end
  
    should "return a valid path some paths have too many forward slashes and some don't. Some arguments are passed in arrays, some as strings" do
      a,b,c,d,e,f,g = 'this/', '//array///', %w[/of/], '/paths/', %w[/has// /far/], '//too/', %w[////many/ /forward// /slashes.txt]
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g)
    end
  
    should "return a valid path some paths have too many forward slashes and some don't. Some arguments are passed in arrays, some as strings, mixed with nil values" do
      a,b,c,d,e,f,g,h,i,j = 'this/', '//array///', nil, %w[/of/], '/paths/', %w[/has// /far/], nil, '//too/', nil, %w[////many/ /forward// /slashes.txt]
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j)
    end
  
    should "return a valid path, even if path ends with many forward slashes" do
      a,b,c,d,e,f,g,h,i,j,k = 'this/', '//array///', nil, %w[/of/], '/paths/', %w[/has// /far/], nil, '//too/', nil, %w[////many/ /forward// /slashes.txt/////]
      assert_equal "this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j)
    end
  
    should "return a valid path, even if the first path is all forward slashes and the supplied paths contain whitespace and line breaks" do
      a,b,c,d,e,f,g,h,i,j,k = "////", '   this/array///', nil, %w[/of/], '/paths/  ', %w[/has// /far/], nil, "//too/\n", nil, ["////many/\n", "  /forward//  ", "\n  /slashes.txt\n\n\n"]
      assert_equal "/this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j,k)
    end
  
    should "return an absolute path with symbols included in the values entered." do
      a,b,c,d,e,f,g,h,i,j = "///this/\n", '   //array///', nil, %w[/of/], :paths, %w[/has// /far/], nil, "//too/\n", nil, ["////many/\n", :forward, "\n  /slashes.txt\n\n\n"]
      assert_equal "/this/array/of/paths/has/far/too/many/forward/slashes.txt", FileUtils.join_paths(a,b,c,d,e,f,g,h,i,j)
    end
  
  end
  
  context "Testing JumpStart::FileUtils#sort_contained_files_and_dirs class method" do
  
    setup do
      @path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_fileutils/sort_contained_files_and_dirs_test"
    end
  
    should "seperate files and dirs contained in the directory specified and output the collections in a hash" do
      results = FileUtils.sort_contained_files_and_dirs(@path)
      assert_equal ["/file_1.txt",
                    "/file_2",
                    "/folder_1/file_3.txt",
                    "/folder_1/folder_2/file_4.txt",
                    "/folder_1/folder_2/folder_3/file_5.txt",
                    "/folder_1/folder_2/folder_4/file_6.txt"], results[:files].sort
      assert_equal ["/folder_1",
                    "/folder_1/folder_2",
                    "/folder_1/folder_2/folder_3",
                    "/folder_1/folder_2/folder_4"], results[:dirs].sort
    end
  
    should "return an empty hash when passed nil" do
      results = FileUtils.sort_contained_files_and_dirs(nil)
      assert_equal( {:files => [], :dirs => []}, results)
    end
  
    should "return an empty hash when passed a path that does not exist" do
      results = FileUtils.sort_contained_files_and_dirs("#{@path}/the_mighty_zargs_imaginary_path")
      assert_equal( {:files => [], :dirs => []}, results)
    end

  end

end
