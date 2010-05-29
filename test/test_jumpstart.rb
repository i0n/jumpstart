require 'helper'

class TestJumpstart < Test::Unit::TestCase
    
  should "be able to find jumpstart_setup.yml" do
    assert(File.exists?("#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml"))
  end
  
  should "be able to find jumpstart_version.yml" do
    assert(File.exists?("#{JumpStart::CONFIG_PATH}/jumpstart_version.yml"))
  end
  
  context "Test for JumpStart.version class instance method" do
    should "return 1.1.1" do
      JumpStart::Setup.version_major = 1
      JumpStart::Setup.version_minor = 1
      JumpStart::Setup.version_patch = 1
      assert_equal "1.1.1", JumpStart.version
    end
  end
  
  context "Tests for launching JumpStart with various configurations set" do
    
    context "JumpStart::Setup.templates_path and JumpStart::Setup.default_template_name are both set to nil as @jumpstart_setup_yaml is not loaded" do
      
      setup do
        JumpStart::Setup.class_eval {@jumpstart_setup_yaml = nil}
        @project.stubs(:jumpstart_menu)
      end
      
      should "launch menu when passed nil. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new([nil])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
        assert_equal nil, @project.instance_eval {@template_name}
      end

      should "launch menu when passed empty. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new([""])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
        assert_equal nil, @project.instance_eval {@template_name}
      end

      should "launch menu when passed one argument under 3 characters. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["no"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
        assert_equal nil, @project.instance_eval {@template_name}
      end

      should "launch menu when passed an ivalid first argument (that starts with a character that is not a letter or number.). JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["$hello"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
        assert_equal nil, @project.instance_eval {@template_name}
      end

      should "launch menu when passed a valid first argument. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["hello"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
        assert_equal nil, @project.instance_eval {@template_name}
      end
      
    end
    
    context "JumpStart::Setup.templates_path is set to and JumpStart::Setup.default_template_name is nil as @jumpstart_setup_yaml is not loaded" do
      
      setup do
        JumpStart::Setup.class_eval {@templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"}
      end
      
      should "loop on check_project_name method when passed one argument under 3 characters and a valid second argument. JumpStart::Setup.templates_path should be set to default." do
        # From the prompt this method would repeat until a valid project name was entered.
        @project = JumpStart::Base.new(["no", "test_template_1"])
        @project.stubs(:jumpstart_menu)
        @project.expects(:check_template_name)
        @project.expects(:check_project_name)
        @project.check_setup
      end

      should "loop on check_project_name method when passed one argument under 3 characters and an invalid second argument. JumpStart::Setup.templates_path should be set to default." do
        # From the prompt this method would repeat until a valid project name was entered.
        @project = JumpStart::Base.new(["no", "this_template_does_not_exist"])
        @project.stubs(:jumpstart_menu)
        @project.expects(:check_template_name)
        @project.expects(:check_project_name)
        @project.check_setup
      end

      should "loop on check_project_name method when passed an ivalid first argument and a valid second argument (that starts with a character that is not a letter or number.). JumpStart::Setup.templates_path should be set to default." do
        # From the prompt this method would repeat until a valid project name was entered.
        @project = JumpStart::Base.new(["$hello", "test_template_1"])
        @project.stubs(:jumpstart_menu)
        @project.expects(:check_template_name)
        @project.expects(:check_project_name)
        @project.check_setup
      end

      should "loop on check_project_name method when passed an ivalid first argument and an invalid second argument (that starts with a character that is not a letter or number.). JumpStart::Setup.templates_path should be set to default." do
        # From the prompt this method would repeat until a valid project name was entered.
        @project = JumpStart::Base.new(["$hello", "this_template_does_not_exist"])
        @project.stubs(:jumpstart_menu)
        @project.expects(:check_template_name)
        @project.expects(:check_project_name)
        @project.check_setup
      end

      should "set @install_path to executing directory when it is not set in the template and when passed a valid first and second argument. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["hello", "test_template_1"])
        # FileUtils.stubs(:pwd)
        @project.stubs(:jumpstart_menu)
        @project.expects(:set_config_file_options)
        @project.expects(:lookup_existing_templates)
        @project.expects(:check_project_name)
        @project.expects(:check_template_name)
        @project.expects(:check_template_path)
        @project.expects(:check_install_path)
        @project.expects(:jumpstart_menu).never
        # FileUtils.expects(:pwd)
        @project.check_setup
        # assert_equal "hello", @project.instance_variable_get(:@install_path)
      end      
      
    end
    
  end 
  
end