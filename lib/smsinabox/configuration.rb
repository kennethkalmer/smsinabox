require 'yaml'

module Smsinabox
  
  # Wrapper around our YAML configuration file, which lives in ~/.smsinabox by
  # default
  class Configuration
    
    def initialize( config_file = nil )
      @config_file = config_file
      
      check_file!
      load_config
    end
    
    def []( key )
      @configuration[key.to_s]
    end
    
    def []=( key, value )
      @configuration[ key.to_s ] = value
    end
    
    def save
      File.open( config_name, 'w' ) do |f|
        YAML::dump( @configuration , f )
      end
      nil
    end
    
    private
    
    def load_config
      begin
        @configuration = File.open( config_name, 'r' ) do |f|
          YAML::load( f )
        end
      rescue
      end
      
      @configuration ||= {}
    end
    
    def check_file!
      unless File.exist?( config_name )
        File.open( config_name, 'w+' ) { |f| f.write('') }
        File.chmod( 0600, config_name )
      end
    end
    
    def config_name
      @config_file || File.expand_path( File.join('~', '.smsinabox') )
    end
  end
end
