require 'helper'

class TestJumpstartFileUtils < Test::Unit::TestCase
  
  context "Testing JumpStart::FileUtils class methods.\n" do
    
    context "Testing JumpStart::FileUtils.append_after_line class method" do
      
    end

    context "Testing JumpStart::FileUtils.append_to_end_of_file class method" do
      
    end

    context "Testing JumpStart::FileUtils.insert_text_at_line_number class method" do
      
    end

    context "Testing JumpStart::FileUtils.remove_files class method" do
      
    end

    context "Testing JumpStart::FileUtils.config_nginx class method" do
      
    end

    context "Testing JumpStart::FileUtils.config_etc_hosts class method" do
      
    end

    context "Testing JumpStart::FileUtils.config_capistrano class method" do
      
    end

    context "Testing JumpStart::FileUtils.make_bare_git_repo class method" do
      
    end

    context "Testing JumpStart::FileUtils.check_source_type class method" do
      
      should "return source as a string" do
        assert_equal("source_as_a_string", JumpStart::FileUtils.check_source_type("source_as_a_string"))
      end
      
    end
    
  end
  
end