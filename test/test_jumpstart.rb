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
  
end