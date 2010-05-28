require 'rubygems'
require 'find'
require 'fileutils'
require 'yaml'
require 'rbconfig'

# Sets up coloured terminal output in windows
if RbConfig::CONFIG['host_os'] =~ /mswin|windows|cygwin|mingw32/
  begin
    require 'Win32/Console/ANSI'
  rescue LoadError
    raise 'You must gem install win32console to use colored output on Windows'
  end
end

module JumpStart
  
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  LIB_PATH = File.expand_path(File.dirname(__FILE__))
  CONFIG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../config'))
  IGNORE_DIRS = ['.','..']
  
  jumpstart_setup_yaml = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")
  jumpstart_version_yaml = YAML.load_file("#{CONFIG_PATH}/jumpstart_version.yml")

  @version_major = jumpstart_version_yaml[:jumpstart_version_major]
  @version_minor = jumpstart_version_yaml[:jumpstart_version_minor]
  @version_patch = jumpstart_version_yaml[:jumpstart_version_patch]
  
  VERSION = "#{@version_major}.#{@version_minor}.#{@version_patch}"
    
  require 'jumpstart/base'
  require 'jumpstart/filetools'
  require 'jumpstart/setup'
  require 'jumpstart/stringtools'
  
  # The path to the jumpstart templates directory. 
  # Set as a module instance variable.
  @templates_path = jumpstart_setup_yaml[:jumpstart_templates_path]
  # sets the default template to use if it has not been passed as an argument.
  # Set as a module instance variable.
  @default_template_name = jumpstart_setup_yaml[:jumpstart_default_template_name]
  
  # Get and Set methods for module instance variables.
  def self.templates_path; @templates_path; end
  def self.templates_path=(value); @templates_path = value; end
  def self.default_template_name; @default_template_name; end
  def self.default_template_name=(value); @default_template_name = value; end
  def self.version_major; @version_major; end
  def self.version_major=(value); @version_major = value; end
  def self.version_minor; @version_minor; end
  def self.version_minor=(value); @version_minor = value; end
  def self.version_patch; @version_patch; end
  def self.version_patch=(value); @version_patch = value; end
        
end

module FileUtils
  class << self
    include JumpStart::FileTools
  end
end

class String
  include JumpStart::StringTools
end

# Set the jumpstart templates path back to default if it has not been set
if JumpStart.templates_path.nil? || JumpStart.templates_path.empty?
  JumpStart.templates_path = "#{JumpStart::ROOT_PATH}/jumpstart_templates"
  JumpStart::Setup.dump_jumpstart_setup_yaml
end
