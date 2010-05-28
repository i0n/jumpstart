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
    
    # Method for bumping version number types.
    def self.bump(version_type)
      eval( "@#{version_type} += 1")
      dump_jumpstart_version_yaml
    end
        
    # Handles calls to JumpStart::Setup.bump_version_major, JumpStart::Setup.bump_version_minor and JumpStart::Setup.bump_version_patch class methods.
    def self.method_missing(method, *args)
      if method.match(/bump_version_(major|minor|patch)/)
        version_type = method.to_s.sub('bump_', '')
        self.send(:bump, "#{version_type}")
      else
        super
      end
    end
    
  end  
end