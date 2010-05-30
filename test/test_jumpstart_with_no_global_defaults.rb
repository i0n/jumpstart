require 'helper'

class TestJumpStartWithNoGlobalDefaults < Test::Unit::TestCase

  context "JumpStart::Setup.templates_path and JumpStart::Setup.default_template_name are both set to nil as @jumpstart_setup_yaml is not loaded" do
  
    setup do
      JumpStart.module_eval {@jumpstart_setup_yaml = nil}
      @project.stubs(:jumpstart_menu)
    end
  
    teardown do
      reset_global_defaults
    end
    
    should "launch menu when passed nil. JumpStart::Setup.templates_path should be set to default." do
      @project = JumpStart::Base.new([nil])
      @project.expects(:jumpstart_menu).once
      @project.set_config_file_options
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.module_eval {@templates_path}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
      assert_equal nil, @project.instance_eval {@template_name}
    end

    should "launch menu when passed empty. JumpStart::Setup.templates_path should be set to default." do
      @project = JumpStart::Base.new([""])
      @project.expects(:jumpstart_menu).once
      @project.set_config_file_options
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.module_eval {@templates_path}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
      assert_equal nil, @project.instance_eval {@template_name}
    end

    should "launch menu when passed one argument under 3 characters. JumpStart::Setup.templates_path should be set to default." do
      @project = JumpStart::Base.new(["no"])
      @project.expects(:jumpstart_menu).once
      @project.set_config_file_options
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.module_eval {@templates_path}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
      assert_equal nil, @project.instance_eval {@template_name}
    end

    should "launch menu when passed an ivalid first argument (that starts with a character that is not a letter or number.). JumpStart::Setup.templates_path should be set to default." do
      @project = JumpStart::Base.new(["$hello"])
      @project.expects(:jumpstart_menu).once
      @project.set_config_file_options
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.module_eval {@templates_path}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
      assert_equal nil, @project.instance_eval {@template_name}
    end

    should "launch menu when passed a valid first argument. JumpStart::Setup.templates_path should be set to default." do
      @project = JumpStart::Base.new(["hello"])
      @project.expects(:jumpstart_menu).once
      @project.set_config_file_options
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.module_eval {@templates_path}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", @project.instance_variable_get(:@template_path)
      assert_equal nil, @project.instance_eval {@template_name}
    end
  
  end
    
end 
