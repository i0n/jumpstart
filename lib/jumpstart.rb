require 'rubygems'
require 'find'
require 'fileutils'
require 'optparse'
require 'yaml'

module JumpStart
  
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  LIB_PATH = File.expand_path(File.dirname(__FILE__))
  CONFIG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../config'))
  IGNORE_DIRS = ['.','..']
  JUMPSTART_TEMPLATES_PATH = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:jumpstart_templates_path]
  DEFAULT_TEMPLATE_NAME = YAML.load_file("#{CONFIG_PATH}/jumpstart_setup.yml")[:default_template_name]
  
  require 'jumpstart/base'
  require 'jumpstart/filetools'
    
end

module FileUtils
  class << self
    include JumpStart::FileTools
  end
end