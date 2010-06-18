$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'uri'
begin
  require 'nokogiri'
rescue LoadError
  require 'rubygems'
  require 'nokogiri'
end

module Smsinabox

  VERSION = '0.2.2'

  autoload :Exceptions,     'smsinabox/exceptions'
  autoload :Message,        'smsinabox/message'
  autoload :Configuration,  'smsinabox/configuration'
  autoload :DeliveryReport, 'smsinabox/delivery_report'
  autoload :SMS,            'smsinabox/sms'
  autoload :Reply,          'smsinabox/reply'
  autoload :SentMessage,    'smsinabox/sent_message'

  class << self

    # Username for the SMS in a Box service
    attr_accessor :username

    # Password for the SMS in a Box service
    attr_accessor :password

    def uri
      @uri ||= URI.parse('http://www.mymobileapi.com/api5/http5.aspx')
    end

    # Return the number of available credits
    def credit_remaining
      perform_request( 'Type' => 'credits' ) do |xml|
        xml.xpath('/api_result/data/credits/text()').to_s.to_i
      end
    end
    alias :credits :credit_remaining

    # Send a #Messages and returns a #DelieryReport
    def deliver( message )
      raise MessageInvalid unless message.valid?

      perform_request(
        'Type' => 'sendparam',
        'return_credits' => 'True',
        'return_msgs_success_count' => 'True',
        'return_msgs_failed_count' => 'True',
        'return_entries_success_status' => 'True',
        'return_entries_failed_status' => 'True',
        'numto' => message.recipient,
        'data1' => message.body
      ) do |response|
        DeliveryReport.from_response( response )
      end
    end

    # Fetch replies from the gateway and then return a collection of replies or
    # yield each reply if a block is given
    def replies( last_id = 0, &block )
      data = [
      "<reply>",
      "<settings>",
      "<id>#{last_id}</id>",
      "<max_recs>100</max_recs>",
      "<cols_returned>eventid,numfrom,receiveddata,received,sentid,sentdata,sentdatetime,sentcustomerid</cols_returned>",
      "</settings>",
      "</reply>"
      ]
      perform_request(
        'Type' => 'replies',
        'XMLData' => data.join
      ) do |response|
        replies = []
        response.xpath('/api_result/data').each do |reply|
          replies << Smsinabox::Reply.from_response( reply )
        end

        replies.each { |r| yield r } if block_given?

        replies
      end
    end

    def sent( last_id = 0, &block )
      data = [
      "<sent>",
      "<settings>",
      "<id>#{last_id}</id>",
      "<max_recs>100</max_recs>",
      "<cols_returned>sentid,eventid,smstype,numto,data,flash,customerid,status,statusdate</cols_returned>",
      "</settings>",
      "</sent>"
      ]

      perform_request(
        'Type' => 'sent',
        'XMLData' => data.join
      ) do |response|
        messages = []
        response.xpath('/api_result/data').each do |msg|
          messages << Smsinabox::SentMessage.from_response( msg )
        end

        messages.each { |m| yield m } if block_given?

        messages
      end
    end

    # Set our username and password from #Smsinabox::Configuration
    def configure!( config_file = nil )
      c = Configuration.new( config_file )
      @username = c["username"]
      @password = c["password"]
      nil
    end

    private

    def perform_request( params = {}, &block )
      raise MissingCredentialException if @username.nil? || @password.nil?
      params.merge!( 'Username' => @username, 'Password' => @password )

      req = Net::HTTP::Post.new( uri.path )
      req.set_form_data( params )
      req['user-agent'] = 'SMS in a Box/' + Smsinabox::VERSION
      res = Net::HTTP.new( uri.host, uri.port ).start { |http| http.request( req ) }
      case res
      when Net::HTTPSuccess
        yield Nokogiri::XML( res.body )
      else
        raise "Could not complete request"
      end
    end

  end

end
