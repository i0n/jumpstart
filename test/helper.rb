require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jumpstart'

class Test::Unit::TestCase

  def reset_global_defaults
    JumpStart::Setup.class_eval do 
      @jumpstart_setup_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml")
      @jumpstart_version_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_version.yml")
      @templates_path = nil
    end
  end

end

module JumpStart
  
  class Base

    # Added monkeypatch for exit methods back until I find a more elegant way to stop generated jumpstarts (jumpstarts that are started programatically during testing) from actually running the exit method.
    # Tests that use this patch: 
    # new_project_from_template_options tests. Starting around line 478 of test_base.rb
    def exit_with_success
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Success! ".green + @project_name.green_bold + " has been created at: ".green + FileUtils.join_paths(@install_path, @project_name).green_bold + "\n\n".green
      puts "******************************************************************************************************************************************\n"
      project = nil
    end
  	
    def exit_normal
      puts "\n\n  Exiting JumpStart...".purple
      puts "\n  Goodbye!\n\n"
      puts "******************************************************************************************************************************************\n"
      project = nil
    end
    
  end
  
end