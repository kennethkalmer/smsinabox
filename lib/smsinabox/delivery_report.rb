module Smsinabox
  class DeliveryReport

    class << self

      # Generate a delivery report from a nokogiri response
      def from_response( nokogiri_xml )
        response = new

        # basic send_info stuff
        response.event_id = nokogiri_xml.xpath('/api_result/send_info/eventid/text()').to_s.to_i
        response.credits = nokogiri_xml.xpath('/api_result/send_info/credits/text()').to_s.to_i
        response.fail_count = nokogiri_xml.xpath('/api_result/send_info/msgs_failed/text()').to_s.to_i
        response.success_count = nokogiri_xml.xpath('/api_result/send_info/msgs_success/text()').to_s.to_i

        # failures
        nokogiri_xml.xpath('/api_result/entries_failed').each do |node|
          response.failures << {
            :numto => node.xpath('./numto/text()').to_s,
            :customerid => node.xpath('./customerid/text()').to_s,
            :reason => node.xpath('./reason/text()').to_s
          }
        end

        # successes
        nokogiri_xml.xpath('/api_result/entries_success').each do |node|
          response.successes << {
            :numto => node.xpath('./numto/text()').to_s,
            :customerid => node.xpath('./customerid/text()').to_s
          }
        end

        response
      end

    end

    attr_accessor :event_id, :credits, :fail_count, :success_count, :failures, :successes

    def initialize
      @fail_count = 0
      @success_count = 0

      @failures = []
      @successes = []
    end

  end
end
