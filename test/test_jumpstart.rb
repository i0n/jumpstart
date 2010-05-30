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
      JumpStart.version_major = 1
      JumpStart.version_minor = 1
      JumpStart.version_patch = 1
      assert_equal "1.1.1", JumpStart.version
    end
  end
  
  context "Tests for the JumpStart::Base#templates_path class method" do
    
    should "return default path if @templates_path is nil when called" do
      JumpStart.module_eval {@templates_path = nil}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.templates_path
    end

    should "return default path if @templates_path is empty when called" do
      JumpStart.module_eval {@templates_path = ""}
      assert_equal "#{JumpStart::ROOT_PATH}/jumpstart_templates", JumpStart.templates_path
    end
    
    should "return the path set" do
      JumpStart.module_eval {@templates_path = "a/path/for/templates"}
      assert_equal "a/path/for/templates", JumpStart.templates_path        
    end
    
  end
  
  context "Tests for the JumpStart#dump_jumpstart_setup_yaml class method." do      
    should "call File.open and Yaml.dump for jumpstart_setup.yml" do
      YAML.stubs(:dump)
      File.stubs(:open)
      File.expects(:open).once
      JumpStart.dump_jumpstart_setup_yaml
    end
  end

  context "Tests for the JumpStart#dump_jumpstart_version_yaml class method." do      
    should "call File.open and Yaml.dump for jumpstart_version.yml" do
      YAML.stubs(:dump)
      File.stubs(:open)
      File.expects(:open).once
      JumpStart.dump_jumpstart_version_yaml
    end
  end

  context "Tests for the JumpStart#bump class method." do
    
    setup do
      JumpStart.stubs(:dump_jumpstart_version_yaml)
    end
    
    should "add 1 to @version_major class instance variable, set @version_minor and @version_patch to 0 and call dump_jumpstart_version_yaml" do
      JumpStart.module_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
      JumpStart.expects(:dump_jumpstart_version_yaml).once
      JumpStart.bump("version_major")
      assert_equal 2, JumpStart.version_major
      assert_equal 0, JumpStart.version_minor
      assert_equal 0, JumpStart.version_patch
    end
    
    should "add 1 to @version_minor class instance variable, set @version_patch to 0 and call dump_jumpstart_version_yaml" do
      JumpStart.module_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
      JumpStart.expects(:dump_jumpstart_version_yaml).once
      JumpStart.bump("version_minor")
      assert_equal 1, JumpStart.version_major
      assert_equal 2, JumpStart.version_minor
      assert_equal 0, JumpStart.version_patch

    end
    
    should "add 1 to @version_patch class instance variable and call dump_jumpstart_version_yaml" do
      JumpStart.module_eval {@version_major = 1; @version_minor = 1; @version_patch = 1 }
      JumpStart.expects(:dump_jumpstart_version_yaml).once
      JumpStart.bump("version_patch")
      assert_equal 1, JumpStart.version_major
      assert_equal 1, JumpStart.version_minor
      assert_equal 2, JumpStart.version_patch

    end
    
  end
  
  context "Tests for the JumpStart#method_missing class method." do
    
    setup do
      JumpStart.stubs(:bump).returns(:result)
      JumpStart.stubs(:dump_jumpstart_version_yaml)
    end
    
    should "recognise JumpStart#bump_version_major class instance method calls and forward them to JumpStart#bump to set @version_major." do
      JumpStart.expects(:bump).with("version_major").once
      JumpStart.bump_version_major
    end

    should "recognise JumpStart#bump_version_minor class instance method calls and forward them to JumpStart#bump to set @version_minor." do
      JumpStart.expects(:bump).with("version_minor").once
      JumpStart.bump_version_minor
    end

    should "recognise JumpStart#bump_version_patch class instance method calls and forward them to JumpStart#bump to set @version_patch." do
      JumpStart.expects(:bump).with("version_patch").once
      JumpStart.bump_version_patch
    end

    should "return method_missing to super as normal if method name is not recognised." do
      assert_raises(NoMethodError) {JumpStart.bump_version_blarg}
    end
    
  end
  
end