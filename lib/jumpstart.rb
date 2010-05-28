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
  
  require 'jumpstart/setup'
  require 'jumpstart/base'
  require 'jumpstart/filetools'
  require 'jumpstart/stringtools'
  
  # Looks up the current version of JumpStart
  def self.version 
    "#{JumpStart::Setup.version_major}.#{JumpStart::Setup.version_minor}.#{JumpStart::Setup.version_patch}"
  end
  
end

module FileUtils
  class << self
    include JumpStart::FileTools
  end
end

class String
  include JumpStart::StringTools
end

