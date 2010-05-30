require 'helper'

class TestJumpStartWithDefaultTemplateSet < Test::Unit::TestCase

  context "JumpStart::Setup.templates_path is set to and JumpStart::Setup.default_template_name is nil as @jumpstart_setup_yaml is not loaded" do

    setup do
      JumpStart.module_eval do 
        @jumpstart_setup_yaml = nil 
        @templates_path = "#{JumpStart::ROOT_PATH}/test/test_jumpstart_templates"
      end
    end
    
    teardown do
      reset_global_defaults    
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
      @project.stubs(:jumpstart_menu)
      @project.expects(:set_config_file_options)
      @project.expects(:check_project_name)
      @project.expects(:check_template_name)
      @project.expects(:check_template_path)
      @project.expects(:check_install_path)
      @project.expects(:jumpstart_menu).never
      @project.check_setup
    end      

  end
  
end