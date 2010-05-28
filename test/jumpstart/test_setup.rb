require 'helper'

class TestJumpstartSetup < Test::Unit::TestCase
  
  context "Testing JumpStart::Setup" do
    
    context "Tests for the JumpStart::Base#templates_path class method" do
      
      should "return default path if @templates_path is nil when called" do
        JumpStart::Setup.class_eval {@templates_path = nil}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.templates_path
      end

      should "return default path if @templates_path is empty when called" do
        JumpStart::Setup.class_eval {@templates_path = ""}
        assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart::Setup.templates_path
      end
      
      should "return the path set" do
        JumpStart::Setup.class_eval {@templates_path = "a/path/for/templates"}
        assert_equal "a/path/for/templates", JumpStart::Setup.templates_path        
      end
      
    end
    
    context "Tests for the JumpStart::Setup#dump_jumpstart_setup_yaml class method." do      
      should "call File.open and Yaml.dump for jumpstart_setup.yml" do
        YAML.stubs(:dump)
        File.stubs(:open)
        File.expects(:open).once
        JumpStart::Setup.dump_jumpstart_setup_yaml
      end
    end

    context "Tests for the JumpStart::Setup#dump_jumpstart_version_yaml class method." do      
      should "call File.open and Yaml.dump for jumpstart_version.yml" do
        YAML.stubs(:dump)
        File.stubs(:open)
        File.expects(:open).once
        JumpStart::Setup.dump_jumpstart_version_yaml
      end
    end

    context "Tests for the JumpStart::Setup#bump class method." do
      
      setup do
        JumpStart::Setup.stubs(:dump_jumpstart_version_yaml)
      end
      
      should "add 1 to @version_major class instance variable, set @version_minor and @version_patch to 0 and call dump_jumpstart_version_yaml" do
        JumpStart::Setup.class_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
        JumpStart::Setup.expects(:dump_jumpstart_version_yaml).once
        JumpStart::Setup.bump("version_major")
        assert_equal 2, JumpStart::Setup.version_major
        assert_equal 0, JumpStart::Setup.version_minor
        assert_equal 0, JumpStart::Setup.version_patch
      end
      
      should "add 1 to @version_minor class instance variable, set @version_patch to 0 and call dump_jumpstart_version_yaml" do
        JumpStart::Setup.class_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
        JumpStart::Setup.expects(:dump_jumpstart_version_yaml).once
        JumpStart::Setup.bump("version_minor")
        assert_equal 1, JumpStart::Setup.version_major
        assert_equal 2, JumpStart::Setup.version_minor
        assert_equal 0, JumpStart::Setup.version_patch

      end
      
      should "add 1 to @version_patch class instance variable and call dump_jumpstart_version_yaml" do
        JumpStart::Setup.class_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
        JumpStart::Setup.expects(:dump_jumpstart_version_yaml).once
        JumpStart::Setup.bump("version_patch")
        assert_equal 1, JumpStart::Setup.version_major
        assert_equal 1, JumpStart::Setup.version_minor
        assert_equal 2, JumpStart::Setup.version_patch

      end
      
    end
    
    context "Tests for the JumpStart::Setup#method_missing class method." do
      
      setup do
        JumpStart::Setup.stubs(:bump).returns(:result)
        JumpStart::Setup.stubs(:dump_jumpstart_version_yaml)
      end
      
      should "recognise JumpStart::Setup#bump_version_major class instance method calls and forward them to JumpStart::Setup#bump to set @version_major." do
        JumpStart::Setup.expects(:bump).with("version_major").once
        JumpStart::Setup.bump_version_major
      end

      should "recognise JumpStart::Setup#bump_version_minor class instance method calls and forward them to JumpStart::Setup#bump to set @version_minor." do
        JumpStart::Setup.expects(:bump).with("version_minor").once
        JumpStart::Setup.bump_version_minor
      end

      should "recognise JumpStart::Setup#bump_version_patch class instance method calls and forward them to JumpStart::Setup#bump to set @version_patch." do
        JumpStart::Setup.expects(:bump).with("version_patch").once
        JumpStart::Setup.bump_version_patch
      end

      should "return method_missing to super as normal if method name is not recognised." do
        assert_raises(NoMethodError) {JumpStart::Setup.bump_version_blarg}
      end
      
    end

  end
  
end