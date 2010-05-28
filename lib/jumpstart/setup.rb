module JumpStart
  class Setup
    
    # Method for writing to config/jumpstart_setup.yml
    def self.dump_jumpstart_setup_yaml
      File.open( "#{CONFIG_PATH}/jumpstart_setup.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_templates_path => JumpStart.templates_path, :jumpstart_default_template_name => JumpStart.default_template_name}, out )
      end
    end
    
    # Method for writing to config/jumpstart_version.yml
    def self.dump_jumpstart_version_yaml
      File.open( "#{CONFIG_PATH}/jumpstart_version.yml", 'w' ) do |out|
        YAML.dump( {:jumpstart_version_major => @version_major, :jumpstart_version_minor => @version_minor, :jumpstart_version_patch => @version_patch}, out )
      end
    end
    
    def self.bump_version_major
      
    end
    
    def self.bump_version_major
      
    end
    
    def self.bump_version_major
      
    end
    
  end  
end