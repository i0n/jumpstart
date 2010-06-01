require 'rubygems'
require 'find'
require 'fileutils'
require 'yaml'
require 'rbconfig'
require 'jumpstart/base'
require 'jumpstart/filetools'
require 'jumpstart/stringtools'

# Included as a module so that extension methods will be better defined in class/module chain.
FileUtils.extend JumpStart::FileTools

# Included as a module so that extension methods will be better defined in class/module chain.
class String
  include JumpStart::StringTools
end

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
  LAUNCH_PATH = FileUtils.pwd

  @jumpstart_setup_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml")
  @jumpstart_version_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_version.yml")

  @version_major = @jumpstart_version_yaml[:jumpstart_version_major]
  @version_minor = @jumpstart_version_yaml[:jumpstart_version_minor]
  @version_patch = @jumpstart_version_yaml[:jumpstart_version_patch]

  class << self

    attr_accessor :default_template_name, :version_major, :version_minor, :version_patch

    # Set the jumpstart templates path back to default if it has not been set
    def templates_path
      if @templates_path.nil? || @templates_path.empty?
        @templates_path = "#{JumpStart::ROOT_PATH}/jumpstart_templates"
      else
        @templates_path
      end
    end

    def templates_path=(value)
      @templates_path = value
    end

    # TODO JumpStart#lookup_existing_templates class instance method needs tests
    def existing_templates
      templates = []
      template_dirs = Dir.entries(templates_path) - IGNORE_DIRS
      template_dirs.each do |x|
        if File.directory?(FileUtils.join_paths(templates_path, x))
          if Dir.entries(FileUtils.join_paths(templates_path, x)).include? "jumpstart_config"
            if File.exists?(FileUtils.join_paths(templates_path, x, '/jumpstart_config/', "#{x}.yml"))
              templates << x
            end
          end
        end
      end
      templates
    end

    # Method for writing to config/jumpstart_setup.yml
    def dump_jumpstart_setup_yaml
      File.open( "#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_templates_path => @templates_path, :jumpstart_default_template_name => @default_template_name}, out )
      end
    end

    # Method for writing to config/jumpstart_version.yml
    def dump_jumpstart_version_yaml
      File.open( "#{JumpStart::CONFIG_PATH}/jumpstart_version.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_version_major => @version_major, :jumpstart_version_minor => @version_minor, :jumpstart_version_patch => @version_patch}, out )
      end
    end

    # Looks up the current version of JumpStart
    def version
      "#{version_major}.#{version_minor}.#{version_patch}"
    end

    # Method for bumping version number types.
    # Resets @version_minor and @version_patch to 0 if bumping @version_major.
    # Resets @version_pacth to 0 if bumping @version_minor
    def bump(version_type)
      value = instance_variable_get("@#{version_type}")
      instance_variable_set("@#{version_type}", (value + 1))
      if version_type == "version_major"
        @version_minor, @version_patch = 0, 0
      elsif version_type == "version_minor"
        @version_patch = 0
      end
      dump_jumpstart_version_yaml
    end

    # Handles calls to JumpStart::Setup.bump_version_major, JumpStart::Setup.bump_version_minor and JumpStart::Setup.bump_version_patch class methods.
    def method_missing(method, *args)
      if method.to_s.match(/^bump_version_(major|minor|patch)$/)
        version_type = method.to_s.sub('bump_', '')
        self.send(:bump, "#{version_type}")
      else
        super
      end
    end

    # Handles calls to missing constants in the JumpStart module. Calls JumpStart.version if JumpStart::VERSION is recognised.
    def const_missing(name)
      if name.to_s =~ /^VERSION$/
        version
      else
        super
      end
    end

  end

  # sets the default template to use if it has not been passed as an argument.
  # Set as a module instance variable.
  if !@jumpstart_setup_yaml[:jumpstart_default_template_name].nil?
    @default_template_name = @jumpstart_setup_yaml[:jumpstart_default_template_name] if existing_templates.include?(@jumpstart_setup_yaml[:jumpstart_default_template_name])
  end

  # The path to the jumpstart templates directory.
  # Set as a module instance variable.
  if !@jumpstart_setup_yaml[:jumpstart_templates_path].nil?
    @templates_path = @jumpstart_setup_yaml[:jumpstart_templates_path] if Dir.exists?(@jumpstart_setup_yaml[:jumpstart_templates_path])
  end

end
