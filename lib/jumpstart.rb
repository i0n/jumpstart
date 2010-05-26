require 'rubygems'
require 'find'
require 'fileutils'
require 'yaml'

# TODO Test this under Windows, and look into conditionally including this dependency with bundler.
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use colored output on Windows'
end

module JumpStart
  
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  LIB_PATH = File.expand_path(File.dirname(__FILE__))
  CONFIG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../config'))
  IGNORE_DIRS = ['.','..']
  
  require 'jumpstart/base'
  require 'jumpstart/filetools'

  # The path to the jumpstart templates directory. 
  # Set as a module instance variable.
  @templates_path = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:jumpstart_templates_path]
  # sets the default template to use if it has not been passed as an argument.
  # Set as a module instance variable.
  @default_template_name = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:jumpstart_default_template_name]
  
  # Get and Set methods for module instance variables.
  def self.templates_path; @templates_path; end
  def self.templates_path=(value); @templates_path = value; end
  def self.default_template_name; @default_template_name; end
  def self.default_template_name=(value); @default_template_name = value; end
    
end

module FileUtils
  class << self
    include JumpStart::FileTools
  end
end

class String
    
  def red;          colourise(self, "\e[31m"); end
  def red_bold;     colourise(self, "\e[1m\e[31m"); end
  def green;        colourise(self, "\e[32m"); end
  def green_bold;   colourise(self, "\e[1m\e[32m"); end
  def yellow;       colourise(self, "\e[1m\e[33m"); end
  def blue;         colourise(self, "\e[34m"); end
  def blue_bold;    colourise(self, "\e[1m\e[34m"); end
  def purple;       colourise(self, "\e[1m\e[35m"); end
  
  def colourise(text, colour_code)  "#{colour_code}#{text}\e[0m" end
  
  # Codes for changing output text:

  # 0   Turn off all attributes
  # 1   Set bright mode
  # 4   Set underline mode
  # 5   Set blink mode
  # 7   Exchange foreground and background colors
  # 8   Hide text (foreground colour would be the same as background)
  # 30  Black text
  # 31  Red text
  # 32  Green text
  # 33  Yellow text
  # 34  Blue text
  # 35  Magenta text
  # 36  Cyan text
  # 37  White text
  # 39  Default text colour
  # 40  Black background
  # 41  Red background
  # 42  Green background
  # 43  Yellow background
  # 44  Blue background
  # 45  Magenta background
  # 46  Cyan background
  # 47  White background
  # 49  Default background colour
      
end