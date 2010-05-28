module JumpStart
  class Setup
    
    class << self
      attr_accessor :templates_path, :default_template_name, :version_major, :version_minor, :version_patch
    end
    
    jumpstart_setup_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml")
    jumpstart_version_yaml = YAML.load_file("#{JumpStart::CONFIG_PATH}/jumpstart_version.yml")

    @version_major = jumpstart_version_yaml[:jumpstart_version_major]
    @version_minor = jumpstart_version_yaml[:jumpstart_version_minor]
    @version_patch = jumpstart_version_yaml[:jumpstart_version_patch]
    
    
    # The path to the jumpstart templates directory. 
    # Set as a module instance variable.
    @templates_path = jumpstart_setup_yaml[:jumpstart_templates_path]
    # sets the default template to use if it has not been passed as an argument.
    # Set as a module instance variable.
    @default_template_name = jumpstart_setup_yaml[:jumpstart_default_template_name]

    # Set the jumpstart templates path back to default if it has not been set
    if @templates_path.nil? || @templates_path.empty?
      @templates_path = "#{JumpStart::ROOT_PATH}/jumpstart_templates"
    end
        
    # Method for writing to config/jumpstart_setup.yml
    def self.dump_jumpstart_setup_yaml
      File.open( "#{JumpStart::CONFIG_PATH}/jumpstart_setup.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_templates_path => @templates_path, :jumpstart_default_template_name => @default_template_name}, out )
      end      
    end
    
    # Method for writing to config/jumpstart_version.yml
    def self.dump_jumpstart_version_yaml
      File.open( "#{JumpStart::CONFIG_PATH}/jumpstart_version.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_version_major => @version_major, :jumpstart_version_minor => @version_minor, :jumpstart_version_patch => @version_patch}, out )
      end
    end
    
    # def self.bump_version_major
    #   JumpStart.version_major += 1
    #   dump_jumpstart_version_yaml
    #   puts "Version is now: #{JumpStart.version_major}.#{JumpStart.version_minor}.#{JumpStart.version_patch}"
    # end
    # 
    # def self.bump_version_minor
    #   JumpStart.version_minor += 1
    #   dump_jumpstart_version_yaml
    #   puts "Version is now: #{JumpStart.version_major}.#{JumpStart.version_minor}.#{JumpStart.version_patch}"
    # end
    # 
    # def self.bump_version_patch
    #   JumpStart.version_patch += 1
    #   dump_jumpstart_version_yaml
    #   puts "Version is now: #{JumpStart.version_major}.#{JumpStart.version_minor}.#{JumpStart.version_patch}"
    # end
    
    def self.method_missing(method, *args)
      if method.match(/bump_version_(major|minor|patch)/)
        method_name = method.to_s.sub('bump_', '').to_sym
        puts "bump method #{method_name} detected"

      else
        puts "NOT FOUND: #{method}"
        # super
      end
    end
    
  end  
end

JumpStart::Setup.dump_jumpstart_setup_yaml

# JumpStart::Setup.bump_version_major
# JumpStart::Setup.bump_version_blarg