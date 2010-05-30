require 'helper'

class TestJumpstartBase < Test::Unit::TestCase
        
  context "Testing JumpStart::Base\n" do
    
    # A valid project with the project name passed in the argument.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      # Creates destination_dir if it does not exist
      unless File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir")
        Dir.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir")
      end
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_1"
      input = StringIO.new
      output = StringIO.new
      @test_project = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project.instance_variable_set(:@input, input)
      @test_project.instance_variable_set(:@output, output)
      @test_project.instance_variable_set(:@template_name, "test_template_1")
      @test_project.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1")
      @test_project.instance_eval {set_config_file_options}
      @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
      @test_project.stubs(:exit_normal)
      @test_project.stubs(:exit_with_success)
    end
    
    # A valid project but with an invalid template name passed in the argument with a valid project name. Project ends up valid as JumpStart.default_template_name is valid and it falls back on this.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      input = StringIO.new
      output = StringIO.new
      @test_project_2 = JumpStart::Base.new(["test_jumpstart_project", "a_name_that_does_not_exist"])
      @test_project_2.instance_eval do
        @input = input
        @output = output
        @template_name = "test_template_2"
        @template_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_2"
        set_config_file_options
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
      @test_project_2.stubs(:exit_normal)
      @test_project_2.stubs(:exit_with_success)
    end
    
    # An invalid project (@template_name), with the project name passed as the argument
    setup do
      @test_project_3 = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project_3.instance_variable_set(:@template_name, "a_name_that_does_not_exist")
      @test_project_3.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_2")
      @test_project_3.stubs(:exit_normal)
      @test_project_3.stubs(:exit_with_success)
    end
    
    # A valid project with the project name passed as the argument 
    setup do
      @test_project_4 = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project_4.instance_variable_set(:@template_name, "test_template_2")
      @test_project_4.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_2")
      @test_project_4.stubs(:exit_normal)
      @test_project_4.stubs(:exit_with_success)       
    end
    
    # An invalid project (@project_name is too short), then passed a valid @project_name through IO.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      input = StringIO.new("testo\n")
      output = StringIO.new
      @test_project_5 = JumpStart::Base.new(["tr"])
      @test_project_5.instance_eval do
        @input = input
        @output = output
        @template_name = "test_template_1"
        set_config_file_options
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
      @test_project_5.stubs(:exit_normal)
      @test_project_5.stubs(:exit_with_success)
    end
    
    # An invalid project (@project_name is nil), then passed a valid @project_name through IO.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      input = StringIO.new("testorama\n")
      output = StringIO.new
      @test_project_6 = JumpStart::Base.new([nil])
      @test_project_6.instance_eval do
        @input = input
        @output = output
        @template_name = "test_template_1"
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
      @test_project_6.stubs(:exit_normal)
      @test_project_6.stubs(:exit_with_success)
      @test_project_6.stubs(:jumpstart_menu)
    end
            
    teardown do
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
    end
    
    context "Tests for the JumpStart::Base#intialize instance method. \n" do
            
      should "set @jumpstart_template_path" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates", JumpStart.templates_path
      end
      
      should "set JumpStart.default_template_name" do
        assert_equal "test_template_1", @test_project.instance_eval {JumpStart.default_template_name}
      end
            
      should "set @project_name" do
        assert_equal "test_jumpstart_project", @test_project.instance_eval {@project_name}
      end
      
      should "set @template_name" do
        assert_equal "test_template_1", @test_project.instance_eval {@template_name}
      end
            
      should "set @template_path" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1", @test_project.instance_eval {@template_path}
      end
      
    end
    
    context "Tests for the JumpStart::Base#set_config_file_options instance method. \n" do
            
      should "set @config_file" do
        assert_equal YAML.load_file("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/#{@test_project_2.instance_variable_get(:@template_name)}/jumpstart_config/#{@test_project_2.instance_variable_get(:@template_name)}.yml"), @test_project_2.instance_variable_get(:@config_file)
      end
      
      should "set @install_path" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/destination_dir", @test_project_2.instance_variable_get(:@install_path) 
      end
      
      should "set @install_command" do
        assert_equal "rails", @test_project_2.instance_variable_get(:@install_command)
      end
      
      should "set @install_command_args" do
        assert_equal "-J -T", @test_project_2.instance_variable_get(:@install_command_args)
      end
      
      should "set @replace_strings" do
        assert_equal [{:target_path=>"/config/deploy.rb", :symbols=>{:project_name=>"name_of_my_app", :remote_server=>"thoughtplant"}}], @test_project_2.instance_variable_get(:@replace_strings)
      end
    
      should "load the jumpstart menu if the specified yaml config file does not exist" do
        @test_project_3.stubs(:jumpstart_menu).returns("jumpstart_menu")
        assert_equal "jumpstart_menu", @test_project_3.set_config_file_options
      end
      
    end
    
    context "Tests for the JumpStart::Base#check_setup instance method. \n" do
      
      should "run contained methods" do
        @test_project_4.stubs(:set_config_file_options).returns("set_config_file_options")
        @test_project_4.stubs(:check_project_name).returns("check_project_name")
        @test_project_4.stubs(:check_template_name).returns("check_template_name")
        @test_project_4.stubs(:check_template_path).returns("check_template_path")
        @test_project_4.stubs(:check_install_path).returns("check_install_path")
        @test_project_4.expects(:set_config_file_options).once
        @test_project_4.expects(:check_project_name).once
        @test_project_4.expects(:check_template_name).once
        @test_project_4.expects(:check_template_path).once
        @test_project_4.expects(:check_install_path).once
        @test_project_4.check_setup
      end
      
    end
        
    context "Tests for the JumpStart::Base#start instance method. \n" do
            
      should "run the contained methods" do
        @test_project.stubs(:execute_install_command).returns("execute_install_command")
        @test_project.stubs(:run_scripts_from_yaml).with(:run_after_install_command).returns("run_after_install_command")
        @test_project.stubs(:parse_template_dir).returns("parse_template_dir")
        @test_project.stubs(:populate_files_from_append_templates).returns("populate_files_from_append_templates")
        @test_project.stubs(:populate_files_from_line_templates).returns("populate_files_from_line_templates")
        @test_project.stubs(:remove_unwanted_files).returns("remove_unwanted_files")
        @test_project.stubs(:run_scripts_from_yaml).with(:run_after_jumpstart).returns("run_after_jumpstart")
        @test_project.stubs(:check_for_strings_to_replace).returns("check_for_strings_to_replace")
        @test_project.stubs(:check_local_nginx_configuration).returns("check_local_nginx_configuration")
        @test_project.expects(:check_setup).once
        @test_project.expects(:execute_install_command).once
        @test_project.expects(:run_scripts_from_yaml).with(:run_after_install_command).once
        @test_project.expects(:parse_template_dir).once
        @test_project.expects(:populate_files_from_append_templates).once
        @test_project.expects(:populate_files_from_line_templates).once
        @test_project.expects(:remove_unwanted_files).once
        @test_project.expects(:run_scripts_from_yaml).with(:run_after_jumpstart).once
        @test_project.expects(:check_for_strings_to_replace).once
        @test_project.expects(:check_local_nginx_configuration).once
        @test_project.expects(:exit_with_success).once
        @test_project.start
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
    
    context "Tests for the JumpStart::Base#check_project_name instance method. \n" do
      
      context "when the project name is over three characters" do
        
        should "return the project name unchanged and without errors" do
          assert_equal @test_project.instance_eval {@project_name}, @test_project.instance_eval {check_project_name}
        end
        
      end
      
      context "when the project name is not empty but is not more than 3 characters" do
                
        should "read input from STDIN" do
          assert_equal "testo\n", @test_project_5.input.string
        end
        
        should "ask the user to provide a longer project name" do
          @test_project_5.instance_eval {check_project_name}
          assert_equal "\e[31m\n  The name tr is too short. Please enter a name at least 3 characters long.\e[0m\n" , @test_project_5.output.string
        end
        
        should "ask the user to provide a longer project name and then return the name of the project when a name longer than three characters is provided" do
          @test_project_5.instance_eval {check_project_name}
          assert_equal "\e[31m\n  The name tr is too short. Please enter a name at least 3 characters long.\e[0m\n" , @test_project_5.output.string
          assert_equal "testo", @test_project_5.instance_eval { check_project_name }
        end
                                
      end
      
      context "when the project name is empty or nil" do
                
        should "ask the user to specify a name for the project if @project_name is empty or nil" do
          @test_project_6.instance_eval {check_project_name}
          assert_equal "\e[1m\e[33m\n  Enter a name for your project.\e[0m\n", @test_project_6.output.string
        end
        
        should "ask the user to specify a name for the project if @project_name is empty or nil and then set it when a name of at least 3 characters is provided" do
          @test_project_6.instance_eval {check_project_name}
          assert_equal "\e[1m\e[33m\n  Enter a name for your project.\e[0m\n", @test_project_6.output.string
          assert_equal "testorama", @test_project_6.instance_eval {check_project_name}
        end
        
      end
      
      context "when the project name begins with a character that is not a number or a letter" do
        
        setup do
          @test_project_6.instance_variable_set(:@project_name, "/fail_with_invalid_character_at_start")
        end
        
        should "ask for a valid project name, display an error message and then set project name when a valid string is provided" do
          assert_equal "/fail_with_invalid_character_at_start", @test_project_6.instance_variable_get(:@project_name)
          @test_project_6.instance_eval {check_project_name}
          assert_equal "\e[31m\n  /fail_with_invalid_character_at_start begins with an invalid character. Please enter a name thats starts with a letter or a number.\e[0m\n", @test_project_6.output.string
        end
        
      end
            
    end
      
    context "Tests for the JumpStart::Base#check_template_name instance method. \n" do
      
      should "launch jumpstart menu if nil" do
        JumpStart.default_template_name = nil
        @test_project.instance_variable_set(:@template_name, nil)
        @test_project.stubs(:jumpstart_menu).returns("jumpstart_menu")
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_eval {check_template_name}
      end
      
      should "launch jumpstart menu if empty" do
        JumpStart.default_template_name = ""
        @test_project.instance_variable_set(:@template_name, "")
        @test_project.stubs(:jumpstart_menu).returns("jumpstart_menu")
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_eval {check_template_name}        
      end
      
    end
    
    context "Test for the JumpStart::Base#check_template_path instance method." do
      
      should "exit the installation if the @template_path directory cannot be found or accessed." do
        @test_project.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/not/a/valid/path")
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {check_template_path}
        assert_equal "\nThe directory \e[31m/Users/i0n/Sites/jumpstart/not/a/valid/path\e[0m could not be found, or you do not have the correct permissions to access it.\n", @test_project.output.string
      end
        
    end
    
    context "Test for the JumpStart::Base#check_install_path instance method" do
      
      should "do nothing if a valid path is set in @install_path and @install_path + @project_name path does not exist yet" do
        assert @test_project.instance_eval {check_install_path}
      end
      
      should "provide a warning and exit JumpStart if the directory path of @install_path + @project_name already exists" do
        FileUtils.mkdir(FileUtils.join_paths(@test_project.instance_variable_get(:@install_path), @test_project.instance_variable_get(:@project_name)))
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {check_install_path}
        assert_equal "\nThe directory \e[31m/Users/i0n/Sites/jumpstart/test/destination_dir/test_jumpstart_project\e[0m already exists.\nAs this is the location you have specified for creating your new project jumpstart will now exit to avoid overwriting anything.\n", @test_project.output.string
      end
      
      should "set the install path to the current directory if @install_path is nil and then run the method again, checking the path of @install_path + @project_name" do
        @test_project.instance_variable_set(:@install_path, nil)
        assert(@test_project.instance_eval {check_install_path})
        assert_equal JumpStart::ROOT_PATH , @test_project.instance_variable_get(:@install_path)
      end
      
    end
    
    context "Tests for the JumpStart::Base#create_template instance method. \n" do
      
      setup do
        JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
        @test_project.instance_variable_set(:@template_name, "testing_create_template")
      end
      
      should "create a template direcotry named after @template_name in the JumpStart.templates_path directory. Inside this dir it will create a /jumpstart_config directory, and inside that it will create a yaml config file called @template_name.yml and populated with JumpStart::ROOT_PATH/source_templates/template_config.yml " do
        @test_project.instance_eval {create_template}
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/testing_create_template/jumpstart_config/testing_create_template.yml")
      end
      
      should "give a message and exit if a directory with the same name as @template_name exists in the JumpStart.templates_path dir" do
        FileUtils.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/testing_create_template")
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {create_template}
        assert_equal "\nThe directory \e[31m/Users/i0n/Sites/jumpstart/test/destination_dir/testing_create_template\e[0m already exists. The template will not be created.\n", @test_project.output.string
      end
      
    end
      
    context "Tests for the JumpStart::Base#jumpstart_menu instance method." do
      
      should "output the users options to the screen and call jumpstart_menu_options" do
        @test_project.stubs(:jumpstart_menu_options)
        @test_project.expects(:jumpstart_menu_options).once
        @test_project.instance_eval {jumpstart_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  JUMPSTART MENU\n\e[0m\n  Here are your options:\n\n\e[1m\e[33m  1\e[0m Create a new project from an existing template.\n\e[1m\e[33m  2\e[0m Create a new template.\n\e[1m\e[33m  3\e[0m Set the default template.\n\e[1m\e[33m  4\e[0m Set the templates directory.\n\n\e[1m\e[33m  x\e[0m Exit jumpstart\n\n******************************************************************************************************************************************\n\n", @test_project.output.string
      end
      
    end
      
    context "Tests for the JumpStart::Base#jumpstart_menu_options instance method. \n" do
      
      setup do
        @test_project.stubs(:new_project_from_template_menu)
        @test_project.stubs(:new_template_menu)
        @test_project.stubs(:set_default_template_menu)
        @test_project.stubs(:templates_dir_menu)
      end
      
      should "run new_project_from_template_menu if input is '1'" do
        @test_project.instance_variable_set(:@input, StringIO.new("1\n"))
        @test_project.expects(:new_project_from_template_menu).once
        @test_project.instance_eval {jumpstart_menu_options}
      end
      
      should "run new_template_menu if input is '2'" do
        @test_project.instance_variable_set(:@input, StringIO.new("2\n"))
        @test_project.expects(:new_template_menu).once
        @test_project.instance_eval {jumpstart_menu_options}      
      end
      
      should "run set_default_template_menu if input is '3'" do
        @test_project.instance_variable_set(:@input, StringIO.new("3\n"))
        @test_project.expects(:set_default_template_menu).once
        @test_project.instance_eval {jumpstart_menu_options}            
      end
      
      should "run templates_dir_menu if input is '4'" do
        @test_project.instance_variable_set(:@input, StringIO.new("4\n"))
        @test_project.expects(:templates_dir_menu).once
        @test_project.instance_eval {jumpstart_menu_options}                  
      end
      
      should "exit if input is 'x'" do
        @test_project.instance_variable_set(:@input, StringIO.new("x\n"))
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {jumpstart_menu_options}                          
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "ask for another input if the value entered is not '1,2,3,4 or x'. Test with 'blarg'" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {jumpstart_menu_options}}
      end
    
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "ask for another input if the value entered is not '1,2,3,4 or x'. Test with 'a'" do
        @test_project.instance_variable_set(:@input, StringIO.new("a\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {jumpstart_menu_options}}
      end
      
    end
    
    context "Tests for the JumpStart::Base#new_project_from_template_menu instance method." do
            
      should "display options and run new_project_from_template_options" do
        @test_project.stubs(:new_project_from_template_options)
        @test_project.expects(:new_project_from_template_options).once
        @test_project.instance_eval {new_project_from_template_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  CREATE A NEW JUMPSTART PROJECT FROM AN EXISTING TEMPLATE\n\n\e[0m\n  Type a number for the template that you want.\n\n  \e[1m\e[33m1\e[0m \e[32mtest_template_1\e[0m\n  \e[1m\e[33m2\e[0m \e[32mtest_template_2\e[0m\n  \e[1m\e[33m3\e[0m \e[32mtest_template_3\e[0m\n\e[1m\e[33m\n  b\e[0m Back to main menu.\n\e[1m\e[33m\n  x\e[0m Exit jumpstart\n\n******************************************************************************************************************************************\n\n", @test_project.output.string
      end
      
    end
      
    context "Tests for the JumpStart::Base#new_project_from_template_options instance method." do
      
      setup do
        @test_project.stubs(:jumpstart_menu)
      end
      
      # TODO Look into testing this method in a different way. The fact that a new class object is instantiated makes it difficult to test with mocha.
      should "create a new project with the specified template name, checking that the project name is valid when a valid number is entered" do
        JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
        JumpStart.default_template_name = "test_template_1"
        @test_project.expects(:check_project_name).once
        @test_project.instance_variable_set(:@input, StringIO.new("1\n"))
        @test_project.instance_eval {new_project_from_template_options}
        assert File.directory?("#{JumpStart::ROOT_PATH}/test_jumpstart_project")
        FileUtils.remove_dir("#{JumpStart::ROOT_PATH}/test_jumpstart_project")
      end
      
      should "launch the jumpstart_menu method if 'b' is entered" do
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_variable_set(:@input, StringIO.new("b\n"))
        @test_project.instance_eval {new_project_from_template_options}
      end
      
      should "exit JumpStart if 'x' is entered." do
        @test_project.expects(:exit_normal).once
        @test_project.instance_variable_set(:@input, StringIO.new("x\n"))
        @test_project.instance_eval {new_project_from_template_options}        
      end
      
      # Raises a NoMethodError in the test as loop is not stopped by user input and cannot perform chomp on nil.
      should "output a message saying that the input has not been understood for any other input" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {new_project_from_template_options}}
        # assert_equal "\e[31mThat command hasn't been understood. Try again!\e[0m\n", @test_project.output.string
      end
      
    end
    
    context "Tests for the JumpStart::Base#new_template_menu instance method." do
      
      should "display output and call new_template_options" do
        @test_project.stubs(:new_template_options)
        JumpStart.expects(:existing_templates).once
        @test_project.expects(:new_template_options).once
        @test_project.instance_eval {new_template_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  CREATE A NEW JUMPSTART TEMPLATE\n\e[0m\n  Existing templates:\n\e[1m\e[33m\n  b\e[0m Back to main menu.\n\e[1m\e[33m\n  x\e[0m Exit jumpstart\n\n", @test_project.output.string
      end
      
    end
    
    context "Tests for the JumpStart::Base#new_template_options instance method." do
      
      setup do
        # JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
        @test_project.stubs(:jumpstart_menu).returns("jumpstart_menu")
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "ask for another template name if the name given is already taken " do
        @test_project.instance_variable_set(:@input, StringIO.new("test_template_1\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {new_template_options}}
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "ask for another template name if the name given is less than 3 characters long." do
        @test_project.instance_variable_set(:@input, StringIO.new("on\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {new_template_options}}
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "ask for another template name if the name given begins with a character that is not a number or a letter." do
        @test_project.instance_variable_set(:@input, StringIO.new("/one\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {new_template_options}}
      end
      
      should "create a new template in the jumpstart templates directory if the name given is valid." do
        @test_project.instance_variable_set(:@input, StringIO.new("four\n"))
        @test_project.instance_eval {new_template_options}
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/four/jumpstart_config/four.yml")
        original_file_contents = IO.read("#{JumpStart::ROOT_PATH}/source_templates/template_config.yml")
        created_file_contents = IO.read("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/four/jumpstart_config/four.yml")
        assert_equal original_file_contents, created_file_contents
        FileUtils.remove_dir("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/four")
      end
      
    end
    
    context "Tests for the JumpStart::Base#set_default_template_menu instance method." do
            
      should "display menu containing contents of JumpStart.existing_templates" do
        @test_project.stubs(:set_default_template_options)
        @test_project.expects(:set_default_template_options).once
        @test_project.instance_eval {set_default_template_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  SELECT A DEFAULT JUMPSTART TEMPLATE\n\n\e[0m\n  \e[1m\e[33m1\e[0m \e[32mtest_template_1\e[0m\n  \e[1m\e[33m2\e[0m \e[32mtest_template_2\e[0m\n  \e[1m\e[33m3\e[0m \e[32mtest_template_3\e[0m\n\e[1m\e[33m\n  b\e[0m Back to main menu.\n\n\e[1m\e[33m  x\e[0m Exit jumpstart\n\n******************************************************************************************************************************************\n\n", @test_project.output.string
      end
      
    end
          
    context "Tests for the JumpStart::Base#set_default_template_options instance method." do
      
      setup do
        @test_project.stubs(:jumpstart_menu)
        JumpStart.stubs(:dump_jumpstart_setup_yaml)
        JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
        JumpStart.default_template_name = "temp_default"
      end
      
      should "set the default template if a number corresponding to an existing template is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("1\n"))
        @test_project.expects(:jumpstart_menu).once
        JumpStart.expects(:dump_jumpstart_setup_yaml).once
        @test_project.instance_eval {set_default_template_options}
        assert_equal "test_template_1", JumpStart.default_template_name
      end
      
      should "go back to the main jumpstart menu if 'b' is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("b\n"))
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_eval {set_default_template_options}
        assert_equal "temp_default", JumpStart.default_template_name
      end
      
      should "exit jumpstart if 'x' is entered" do
        @test_project.instance_variable_set(:@input, StringIO.new("x\n"))
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {set_default_template_options}
        assert_equal "temp_default", JumpStart.default_template_name        
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "restart the set_default_template_options method if the command is not understood" do
        @test_project.instance_variable_set(:@input, StringIO.new("super_blarg\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {set_default_template_options}}
      end
      
    end
    
    context "Tests for the JumpStart::Base#templates_dir_menu instance method." do
      
      should "display options and call templates_dir_options method." do
        @test_project.stubs(:templates_dir_options)
        @test_project.expects(:templates_dir_options).once
        @test_project.instance_eval {templates_dir_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  JUMPSTART TEMPLATES DIRECTORY OPTIONS\n\n\e[0m\n\e[1m\e[33m  1\e[0m Set templates directory.\n\e[1m\e[33m  2\e[0m Reset templates directory to default\n\n\e[1m\e[33m  b\e[0m Back to main menu.\n\n\e[1m\e[33m  x\e[0m Exit jumpstart\n\n******************************************************************************************************************************************\n\n", @test_project.output.string
      end
      
    end
    
    context "Tests for the JumpStart::Base#templates_dir_options instance method." do
      
      setup do
        @test_project.stubs(:set_templates_dir)
        @test_project.stubs(:reset_templates_dir_to_default_check)
        @test_project.stubs(:jumpstart_menu)
      end
      
      should "run the set_templates_dir method when '1' is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("1\n"))
        @test_project.expects(:set_templates_dir).once
        @test_project.instance_eval {templates_dir_options}
      end
    
      should "run the reset_templates_dir_to_default method when '2' is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("2\n"))
        @test_project.expects(:reset_templates_dir_to_default_check).once
        @test_project.instance_eval {templates_dir_options}
      end
    
      should "run the jumpstart_menu method when 'b' is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("b\n"))
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_eval {templates_dir_options}
      end
    
      should "run the exit_normal when 'x' is entered." do
        @test_project.instance_variable_set(:@input, StringIO.new("x\n"))
        @test_project.expects(:exit_normal).once
        @test_project.instance_eval {templates_dir_options}
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "restart the method if the command entered is not understood" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {templates_dir_options}}
      end
      
    end
    
    context "Tests for the JumpStart::Base#set_templates_dir instance method." do
      
      setup do
        JumpStart.stubs(:dump_jumpstart_setup_yaml)
        @test_project.stubs(:jumpstart_menu)
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "restart the method if the directory path provided already exists." do
        @test_project.instance_variable_set(:@input, StringIO.new("#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1"))
        assert_raises(NoMethodError) {@test_project.instance_eval {set_templates_dir}}
      end
      
      should "create a new directory and copy existing templates into it, then set JumpStart.templates_path to the new location." do
        @test_project.instance_variable_set(:@input, StringIO.new("#{JumpStart::ROOT_PATH}/test/destination_dir/a_name_that_does_not_exist"))
        JumpStart.expects(:dump_jumpstart_setup_yaml).once
        @test_project.expects(:jumpstart_menu).once
        @test_project.instance_eval {set_templates_dir}
        assert_equal "\nCopying existing templates to /Users/i0n/Sites/jumpstart/test/destination_dir/a_name_that_does_not_exist\n\e[32m\nTransfer complete!\e[0m\n", @test_project.output.string
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/a_name_that_does_not_exist/test_template_1/jumpstart_config/test_template_1.yml")
      end
      
    end
          
    context "Tests for the JumpStart::Base#reset_templates_dir_to_default_check instance method." do
      
      setup do
        @test_project.stubs(:templates_dir_menu)
        @test_project.stubs(:reset_templates_dir_to_default_set)
      end
      
      should "output a message and run templates_dir_menu if JumpStart.templates_path is set to it's standard starting position." do
        JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/jumpstart_templates"
        @test_project.expects(:templates_dir_menu).once
        @test_project.instance_eval {reset_templates_dir_to_default_check}
        assert_equal "\e[31m  You do not need to reset the jumpstart templates directory, it is already set to: /Users/i0n/Sites/jumpstart/jumpstart_templates\e[0m\n", @test_project.output.string
      end
      
      should "run reset_templates_dir_to_default_set if the current JumpStart.templates_path is not the default." do
        JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
        @test_project.expects(:reset_templates_dir_to_default_set).once
        @test_project.instance_eval {reset_templates_dir_to_default_check}
        assert_equal "  Resetting the jumpstart templates directory to the default: /Users/i0n/Sites/jumpstart/jumpstart_templates\n\n\e[1m\e[33m  Moving your jumpstart templates back to the default directory will delete any templates that are currently there. Proceed?\n\e[0m\n  Type yes (\e[1m\e[33my\e[0m) or no (\e[1m\e[33mn\e[0m)\n\n", @test_project.output.string
      end
      
    end
    
    context "Tests for the JumpStart::Base#reset_templates_dir_to_default_set instance method." do
      
      setup do
        JumpStart.stubs(:dump_jumpstart_setup_yaml)
        @test_project.stubs(:templates_dir_menu)
        FileUtils.mkdir("#{JumpStart::ROOT_PATH}/test/destination_dir/jumpstart_templates")
        @normal_root_path = JumpStart::ROOT_PATH.dup
        JumpStart::ROOT_PATH = "#{@normal_root_path}/test/destination_dir"
        JumpStart.templates_path = "#{@normal_root_path}/test/test_jumpstart_templates/test_base"
        @test_project.instance_variable_set(:@current_files_and_dirs, {:files => ['current_files_and_dirs_test_file.txt'], :dirs => ['current_files_and_dirs_test_dir']})
      end
    
      teardown do
        JumpStart::ROOT_PATH = @normal_root_path
      end
      
      should "reset jumpstart templates directory to default if input is 'y'" do
        @test_project.expects(:templates_dir_menu)
        @test_project.instance_variable_set(:@input, StringIO.new("y\n"))
        @test_project.instance_eval {reset_templates_dir_to_default_set}
        assert_equal "\e[32m\n  SUCCESS! the jumpstart templates directory has been set to the default: /Users/i0n/Sites/jumpstart/test/destination_dir/jumpstart_templates\e[0m\n", @test_project.output.string
        assert File.exists?("#{JumpStart::ROOT_PATH}/jumpstart_templates/current_files_and_dirs_test_file.txt")
        assert File.directory?("#{JumpStart::ROOT_PATH}/jumpstart_templates/current_files_and_dirs_test_dir")
      end
    
      should "reset jumpstart templates directory to default if input is 'yes'" do
        @test_project.expects(:templates_dir_menu)
        @test_project.instance_variable_set(:@input, StringIO.new("yes\n"))
        @test_project.instance_eval {reset_templates_dir_to_default_set}
        assert_equal "\e[32m\n  SUCCESS! the jumpstart templates directory has been set to the default: /Users/i0n/Sites/jumpstart/test/destination_dir/jumpstart_templates\e[0m\n", @test_project.output.string
        assert File.exists?("#{JumpStart::ROOT_PATH}/jumpstart_templates/current_files_and_dirs_test_file.txt")
        assert File.directory?("#{JumpStart::ROOT_PATH}/jumpstart_templates/current_files_and_dirs_test_dir")
      end
      
      should "run templates_dir_menu if input is 'n'" do
        @test_project.expects(:templates_dir_menu)
        @test_project.instance_variable_set(:@input, StringIO.new("n\n"))
        @test_project.instance_eval {reset_templates_dir_to_default_set}
        assert_equal "\n You have chosen not to move the jumpstart templates directory, nothing has been changed.\n", @test_project.output.string
      end
    
      should "run templates_dir_menu if input is 'no'" do
        @test_project.expects(:templates_dir_menu)
        @test_project.instance_variable_set(:@input, StringIO.new("no\n"))
        @test_project.instance_eval {reset_templates_dir_to_default_set}
        assert_equal "\n You have chosen not to move the jumpstart templates directory, nothing has been changed.\n", @test_project.output.string
      end
      
      # Due to the recursive nature of this code, the only successful way to test is to check for the NoMethodError that is raised when the method is called for a second time, this time with @input as nil. I'd be interested to find another way to test this.
      should "restart the method if the input is not understood" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        assert_raises(NoMethodError) {@test_project.instance_eval {reset_templates_dir_to_default_set}}
      end
      
    end
    
    context "Tests for the JumpStart::Base#execute_install_command instance method." do
            
      should "do nothing if @install_command is nil" do
        @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
        @test_project.instance_variable_set(:@install_command, nil)
        @test_project.instance_variable_set(:@install_command_args, "test")
        @test_project.instance_eval {execute_install_command}
        assert_equal "", @test_project.output.string
      end
      
      should "do nothing if @install_command is empty" do
        @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
        @test_project.instance_variable_set(:@install_command, "")
        @test_project.instance_variable_set(:@install_command_args, "test")
        @test_project.instance_eval {execute_install_command}
        assert_equal "", @test_project.output.string
      end
    
      should "execute @install_command if it contains a string" do
        @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
        @test_project.instance_variable_set(:@install_command, "echo")
        @test_project.instance_variable_set(:@install_command_args, "install command args")
        @test_project.expects(:system).once
        @test_project.instance_eval {execute_install_command}
        assert_equal "Executing command: \e[32mecho\e[0m \e[32mtest_jumpstart_project\e[0m \e[32minstall command args\e[0m\n", @test_project.output.string
      end      
    
      should "raise an error if the @install_path does not exist" do
        @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir/this/dir/does/not/exist")
        @test_project.instance_variable_set(:@install_command, "echo")
        @test_project.instance_variable_set(:@install_command_args, "install command args")
        assert_raises(Errno::ENOENT) {@test_project.instance_eval {execute_install_command}}
      end      
      
    end
    
    context "Tests for the JumpStart::Base#parse_template_dir instance method." do
      
      setup do
        @test_project.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
        FileUtils.mkdir_p("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/nginx.local.conf")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/nginx.remote.conf")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_._append_test_1.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_._append_test_2")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_l._append_test_3.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_L._append_test_4.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_._append_test_5.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_._append_test_6")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_l._append_test_7.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_L._append_test_8.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_1._line_test_1.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/_1._line_test_2")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_1._line_test_3.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/_10000._line_test_4.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/whole_test_1.txt")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/whole_test_2")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/whole_test_3")
        FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/whole_test_4.txt")
        @test_project.instance_eval {parse_template_dir}
      end
      
      should "populate @dir_list with directories contained in @template_path" do
        assert_equal ['', '/parse_template_dir'], @test_project.instance_variable_get(:@dir_list).sort
      end
      
      should "populate @append_templates with files that are prefixed with _._ _l._ or _L._ and do not contain a directory called jumpstart_config." do
        assert_equal ["/parse_template_dir/_._append_test_5.txt",
                      "/parse_template_dir/_._append_test_6",
                      "/parse_template_dir/_L._append_test_8.txt",
                      "/parse_template_dir/_l._append_test_7.txt"], @test_project.instance_variable_get(:@append_templates).sort
      end
      
      should "populate @line_templates with files that are prefixed with _(number)._ e.g. _1._ or _1000._. File paths that include a directory called jumpstart_config should be excluded." do
        assert_equal ["/parse_template_dir/_1._line_test_3.txt",
                      "/parse_template_dir/_10000._line_test_4.txt"], @test_project.instance_variable_get(:@line_templates).sort
      end
      
      should "populate @whole_templates with a files that do not match append or line templates and do not contain a directory called jumpstart_config in their path." do
        assert_equal ["/parse_template_dir/whole_test_3", "/parse_template_dir/whole_test_4.txt"], @test_project.instance_variable_get(:@whole_templates).sort
      end
      
      should "populate @nginx_local_template if a file matching jumpstart_config/nginx.local.conf is found" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/nginx.local.conf", @test_project.instance_variable_get(:@nginx_local_template)
      end
    
      should "populate @nginx_remote_template if a file matching jumpstart_config/nginx.remote.conf is found" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/destination_dir/parse_template_dir/jumpstart_config/nginx.remote.conf", @test_project.instance_variable_get(:@nginx_remote_template)
      end
      
    end
    
    context "Tests for the JumpStart::Base#create_dirs instance method." do
      
      should "create dirs even if paths have too many or too few forward slashes" do
        @test_project.instance_variable_set(:@install_path, "#{JumpStart::ROOT_PATH}/test/destination_dir")
        @test_project.instance_variable_set(:@project_name, 'create_dirs_test' )
        @test_project.instance_variable_set(:@dir_list, %w[1 //2// /3 ///4 5/// /6/] )
        @test_project.instance_eval {create_dirs}
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/1")
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/2")
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/3")
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/4")
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/5")
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/create_dirs_test/6")
      end
      
    end
    
    context "Tests for the JumpStart::Base#populate_files_from_whole_templates instance method." do
            
      should "create files from @whole_templates" do
        @test_project.instance_eval {parse_template_dir}
        @test_project.instance_eval {create_dirs}
        @test_project.instance_eval {populate_files_from_whole_templates}
        assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_with_extension.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_whole_file_without_extension")
      end
      
    end
    
    context "Tests for the JumpStart::Base#populate_files_from_append_templates instance method." do
                  
      should "append contents of append template to file." do
        @test_project.instance_eval {parse_template_dir}
        @test_project.instance_eval {create_dirs}
        @test_project.instance_eval {populate_files_from_whole_templates}
        @test_project.instance_eval {populate_files_from_append_templates}
        file_1 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_1.txt")
        file_2 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
        assert_equal "THIS IS THE LAST LINE\n", file_1[9]
        assert_equal "THIS IS THE LAST LINE\n", file_2[9]
        assert_equal "9\n", file_1[8]
        assert_equal "9\n", file_2[8]
        assert !file_1[10]
        assert !file_2[10]
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_with_extension.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_file_without_extension")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_with_extension.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_append_file_without_extension")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_1.txt")
        assert !File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_L._test_append_to_end_of_file_remove_last_line_1.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
        assert !File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_l._test_append_to_end_of_file_remove_last_line_2.txt")
      end
      
    end
    
    context "Tests for the JumpStart::Base#populate_files_from_line_templates instance method. \n" do
      
      should "append contents of line templates to the relevant file." do
        @test_project.instance_eval {parse_template_dir}
        @test_project.instance_eval {create_dirs}
        @test_project.instance_eval {populate_files_from_whole_templates}
        @test_project.instance_eval {populate_files_from_append_templates}
        @test_project.instance_eval {populate_files_from_line_templates}
        file = "#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_without_extension"
        assert File.exists?(file)
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_line_file_with_extension.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_with_extension.txt")
        assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/normal_folder_name/test_line_file_without_extension")
        file_lines = IO.readlines(file)
        assert_equal( "Lorem\n", file_lines[19])
      end
      
    end
    
    context "Tests for the JumpStart::Base#check_local_nginx_configuration instance method. \n" do
      
      setup do
        FileUtils.stubs(:config_nginx)
        FileUtils.stubs(:config_hosts)
      end
      
      should "produce an error and not try to configure Nginx if @nginx_local_template is nil" do
        @test_project.instance_variable_set(:@config_file, {:local_nginx_conf => "something"})
        @test_project.instance_variable_set(:@nginx_local_template, nil)
        @test_project.instance_eval {check_local_nginx_configuration}
        assert_equal "  \nNginx will not be configured as options have not been set for this.\n", @test_project.output.string        
      end
      
      should "produce an error and not try to configure Nginx if @config_file[:local_nginx_conf] is nil" do
        @test_project.instance_variable_set(:@config_file, {:local_nginx_conf => nil})
        @test_project.instance_variable_set(:@nginx_local_template, "something")
        @test_project.instance_eval {check_local_nginx_configuration}
        assert_equal "  \nNginx will not be configured as options have not been set for this.\n", @test_project.output.string
      end
      
      should "try and run FileUtils.config_nginx and FileUtils.config_hosts if both @nginx_local_template and @config_file[:local_nginx_conf] are set." do
        @test_project.instance_variable_set(:@config_file, {:local_nginx_conf => "something"})
        @test_project.instance_variable_set(:@nginx_local_template, "something")
        FileUtils.expects(:config_nginx).once
        FileUtils.expects(:config_hosts).once
        @test_project.instance_eval {check_local_nginx_configuration}        
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
      
      should "do nothing if passed nil" do
        @test_project.instance_eval {@config_files = {:remove_files => nil}}
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
    
    context "Tests for the JumpStart::Base#check_for_strings_to_replace instance method.\n" do
      
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
        assert !@test_project.instance_eval {check_for_strings_to_replace}
      end
      
      should "return false if @replace_strings is populated with an empty entry." do
        @test_project.instance_eval {@replace_strings = [{:target_path => nil, :symbols => nil}]}
        assert !@test_project.instance_eval {check_for_strings_to_replace}
      end
      
    end
        
    context "Tests for the JumpStart::Base#exit_with_success instance method." do
      # As these methods are very simple exit (end script) methods, and are already patched for testing, seems pointless to write tests for them.
    end
    
    context "Tests for the JumpStart::Base#exit_normal instance method." do
      # As these methods are very simple exit (end script) methods, and are already patched for testing, seems pointless to write tests for them.
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
        assert !JumpStart::Base.remove_last_line?("/path/to/file.txt")
        assert !JumpStart::Base.remove_last_line?("/path/to/_._file.txt")
        assert !JumpStart::Base.remove_last_line?("_.__file.txt")
        assert !JumpStart::Base.remove_last_line?("/path/to/_R._file.txt")
        assert !JumpStart::Base.remove_last_line?("/path/to/_.1_file.txt")
        assert !JumpStart::Base.remove_last_line?("/path/to/_1._file.txt")
        assert !JumpStart::Base.remove_last_line?("/path/to/_111._file.txt")
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
          assert @test_project
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
          assert File.directory?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project")
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
          assert !File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_L._test_append_to_end_of_file_remove_last_line_1.txt")
          assert File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
          assert !File.exists?("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/_l._test_append_to_end_of_file_remove_last_line_2.txt")
        end
            
        should "remove last lines from files and append template info" do
          @test_project.start
          file_1 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_1.txt")
          file_2 = IO.readlines("#{JumpStart::ROOT_PATH}/test/destination_dir/test_jumpstart_project/test_append_to_end_of_file_remove_last_line_2.txt")
          assert_equal "THIS IS THE LAST LINE\n", file_1[9]
          assert_equal "THIS IS THE LAST LINE\n", file_2[9]
          assert_equal "9\n", file_1[8]
          assert_equal "9\n", file_2[8]
          assert !file_1[10]
          assert !file_2[10]
        end
      
      end
      
    end
                             
  end
end