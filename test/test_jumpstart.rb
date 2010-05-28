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
      end

      should "launch menu when passed empty. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new([""])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
      end

      should "launch menu when passed one argument under 3 characters. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["no"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
      end

      should "launch menu when passed an ivalid first argument (that starts with a character that is not a letter or number.). JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["$hello"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
      end

      should "launch menu when passed a valid first argument. JumpStart::Setup.templates_path should be set to default." do
        @project = JumpStart::Base.new(["hello"])
        @project.expects(:jumpstart_menu).once
        @project.set_config_file_options
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.class_eval {@templates_path}
      end
      
      
    end
    
  end 
  
end