require 'find'
require 'fileutils'
require 'optparse'
require 'yaml'

module JumpStart
  
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  LIB_PATH = File.expand_path(File.dirname(__FILE__))
  CONFIG_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../config'))
  IGNORE_DIRS = ['.','..']
  
  require 'jumpstart/base'
  require 'jumpstart/fileutils'
  
end