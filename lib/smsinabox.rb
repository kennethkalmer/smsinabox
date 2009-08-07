$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'

require 'smsinabox/exceptions'
require 'smsinabox/message'
require 'smsinabox/configuration'

module Smsinabox

  VERSION = '0.2.0'
  
  class << self
    
    # Username for the SMS in a Box service
    attr_accessor :username
    
    # Password for the SMS in a Box service
    attr_accessor :password
    
    # Return the number of available credits
    def credits
      perform_request( 'type' => 'credits' ).to_i
    end
    
    # Send a SMS messages and return the message ID
    def send( message )
      raise MessageInvalid unless message.valid?
      
      perform_request( 
        'type' => 'singlesms', 'Number' => message.recipient, 
        'Message' => message.body 
      )
    end
    
    # Set our username and password from #Smsinabox::Configuration
    def configure!( config_file = nil )
      c = Configuration.new( config_file )
      @username = c["username"]
      @password = c["password"]
      nil
    end
    
    private
    
    def perform_request( params = {})
      raise MissingCredentialException if @username.nil? || @password.nil?
      params.merge!( 'username' => @username, 'password' => @password )
      
      url = URI.parse( "http://www.smsinabox.co.za/httppost4.aspx" )
      req = Net::HTTP::Post.new( url.path )
      req.set_form_data( params )
      req['user-agent'] = 'SMS in a Box/' + Smsinabox::VERSION::STRING
      res = Net::HTTP.new( url.host, url.port ).start { |http| http.request( req ) }
      case res
      when Net::HTTPSuccess
        return res.body
      else
        raise "Could not complete request"
      end
    end
    
  end
  
end
