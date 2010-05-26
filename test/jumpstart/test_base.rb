require 'helper'

class TestJumpstartBase < Test::Unit::TestCase
        
  context "Testing JumpStart::Base with a JumpStart.default_template_name and JumpStart.templates_path specified.\n" do
    
    # A valid project with the project name passed in the argument.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_1"
      input = StringIO.new
      output = StringIO.new
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
      @test_project = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project.instance_eval do
        @input = input
        @output = output
        @template_name = "test_template_1"
        @template_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_1"
        set_config_file_options
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
      @test_project.stubs(:exit_normal)
      @test_project.stubs(:exit_with_success)
    end
    
    # A valid project but with an invalid template name passed in the argument with a valid project name. Project ends up valid as JumpStart.default_template_name is valid and it falls back on this.
    # IO has been setup for testing
    # runs set_config_file_options to set all instance variables
    setup do
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_2"
      input = StringIO.new
      output = StringIO.new
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
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
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_2"
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
      @test_project_3 = JumpStart::Base.new(["test_jumpstart_project"])
      @test_project_3.instance_variable_set(:@template_name, "a_name_that_does_not_exist")
      @test_project_3.instance_variable_set(:@template_path, "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates/test_template_2")
      @test_project_3.stubs(:exit_normal)
      @test_project_3.stubs(:exit_with_success)
    end
    
    # A valid project with the project name passed as the argument 
    setup do
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_2"
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
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
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_1"
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
      JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      JumpStart.default_template_name = "test_template_1"
      input = StringIO.new("testorama\n")
      output = StringIO.new
      @test_project_6 = JumpStart::Base.new([nil])
      @test_project_6.instance_eval do
        @input = input
        @output = output
        @template_name = "test_template_1"
        set_config_file_options
        @install_path = "#{JumpStart::ROOT_PATH}/test/destination_dir"
      end
      @test_project_6.stubs(:exit_normal)
      @test_project_6.stubs(:exit_with_success)
    end
        
    teardown do
      FileUtils.delete_dir_contents("#{JumpStart::ROOT_PATH}/test/destination_dir")
      FileUtils.touch("#{JumpStart::ROOT_PATH}/test/destination_dir/.gitignore")
    end
    
    context "Tests for the JumpStart::Base#intialize instance method. \n" do
            
      should "set @jumpstart_template_path" do
        assert_equal "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates", @test_project.instance_eval {JumpStart.templates_path}
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
        @test_project_4.stubs(:lookup_existing_templates).returns("lookup_existing_templates")
        @test_project_4.stubs(:check_project_name).returns("check_project_name")
        @test_project_4.stubs(:check_template_name).returns("check_template_name")
        @test_project_4.stubs(:check_template_path).returns("check_template_path")
        @test_project_4.stubs(:check_install_path).returns("check_install_path")
        @test_project_4.expects(:set_config_file_options).once
        @test_project_4.expects(:lookup_existing_templates).once
        @test_project_4.expects(:check_project_name).once
        @test_project_4.expects(:check_template_name).once
        @test_project_4.expects(:check_template_path).once
        @test_project_4.expects(:check_install_path).once
        @test_project_4.check_setup
      end
      
    end
    
    context "Tests for the JumpStart::Base#lookup_existing_projects instance method. \n" do
      
      should "run lookup_existing_projects method and return an array of existing templates" do
        @test_project.lookup_existing_templates
        assert_equal %w[test_template_1 test_template_2 test_template_3], @test_project.instance_eval {@existing_templates}
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
        assert_equal FileUtils.pwd , @test_project.instance_variable_get(:@install_path)
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
        @test_project.stubs(:lookup_existing_templates)
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
      
      should "ask for another input if the value entered is not '1,2,3,4 or x'. Test with 'blarg'" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        @test_project.expects(:jumpstart_menu_options).once
        @test_project.instance_eval {jumpstart_menu_options}
      end

      should "ask for another input if the value entered is not '1,2,3,4 or x'. Test with 'a'" do
        @test_project.instance_variable_set(:@input, StringIO.new("a\n"))
        @test_project.expects(:jumpstart_menu_options).once
        @test_project.instance_eval {jumpstart_menu_options}
      end
      
    end
    
    context "Tests for the JumpStart::Base#new_project_from_template_menu instance method." do
            
      should "display options and run new_project_from_template_options" do
        @test_project.stubs(:new_project_from_template_options)
        @test_project.expects(:new_project_from_template_options).once
        @test_project.instance_variable_set(:@existing_templates, %w[project1 project2 project3])
        @test_project.instance_eval {new_project_from_template_menu}
        assert_equal "\n\n******************************************************************************************************************************************\n\n\e[1m\e[35m  CREATE A NEW JUMPSTART PROJECT FROM AN EXISTING TEMPLATE\n\n\e[0m\n  Type a number for the template that you want.\n\n  \e[1m\e[33m1\e[0m project1\n  \e[1m\e[33m2\e[0m project2\n  \e[1m\e[33m3\e[0m project3\n\e[1m\e[33m\n  b\e[0m Back to main menu.\n\e[1m\e[33m\n  x\e[0m Exit jumpstart\n\n******************************************************************************************************************************************\n\n", @test_project.output.string
        assert_equal ['project1', 'project2', 'project3'], @test_project.instance_variable_get(:@existing_templates)
      end
      
    end
      
    context "Tests for the JumpStart::Base#new_project_from_template_options instance method." do
      
      setup do
        # @test_project.stubs(:check_project_name)
        @test_project.stubs(:jumpstart_menu)
        # project.stubs(:check_setup)
        # project.stubs(:start)
        # @test_project.instance_variable_set(:@existing_templates, %w[project1 project2 project3])
        @test_project.instance_eval {lookup_existing_templates}
      end
      
      should "create a new project with the specified template name, checking that the project name is valid when a valid number is entered" do
        # @test_project.expects(:check_project_name).once
        # @test_project.instance_variable_set(:@input, StringIO.new("1\n"))
        # @test_project.instance_eval {new_project_from_template_options}
        
        # Testing what has been set
        # assert_equal "", @test_project.instance_variable_get(:@existing_templates)
        # assert_equal "", @test_project.instance_variable_get(:JumpStart.templates_path)
        # assert_equal "", @test_project.instance_variable_get(:@template_name)
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
      
      should "output a message saying that the input has not been understood for any other input" do
        @test_project.instance_variable_set(:@input, StringIO.new("blarg\n"))
        @test_project.instance_eval {new_project_from_template_options}        
        assert_equal "\e[31mThat command hasn't been understood. Try again!\e[0m\n", @test_project.output.string
      end
      
    end
    
    # def new_project_from_template_options
    #   input = gets.chomp.strip
    #   case
    #   when input.to_i <= @existing_templates.count && input.to_i > 0
    #     @template_name = @existing_templates[(input.to_i - 1)]
    #     check_project_name
    #     project = JumpStart::Base.new([@project_name, @template_name])
    #     project.check_setup
    #     project.start
    #   when input == "b"
    #     jumpstart_menu
    #   when input == "x"
    #     exit_normal
    #   else
    #     puts "That command hasn't been understood. Try again!".red
    #   end
    # end
    
      
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
        refute(@test_project.instance_eval {check_for_strings_to_replace})
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