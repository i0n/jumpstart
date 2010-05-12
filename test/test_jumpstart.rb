require 'helper'

class TestJumpstart < Test::Unit::TestCase
    
  should "be able to find jumpstart_setup.yml" do
    assert(File.exists?("#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml"))
  end
  
end