module Smsinabox
  class SentMessage

    class << self

      # Generate a #SentMessage from a response xml fragment
      def from_response( nokogiri_xml )
        msg = new

        msg.id = nokogiri_xml.xpath('./sentid/text()').to_s.to_i
        msg.change_id = nokogiri_xml.xpath('./changeid/text()').to_s.to_i
        msg.event_id = nokogiri_xml.xpath('./eventid/text()').to_s.to_i
        msg.type = nokogiri_xml.xpath('./smstype/text()').to_s
        msg.to = nokogiri_xml.xpath('./numto/text()').to_s
        msg.message = nokogiri_xml.xpath('./data/text()').to_s
        msg.flash = nokogiri_xml.xpath('./flash/text()').to_s == 'true'
        msg.customer_id = nokogiri_xml.xpath('./customerid/text()').to_s
        msg.status = nokogiri_xml.xpath('./status/text()').to_s
        msg.status_date = nokogiri_xml.xpath('./statusdate/text()').to_s

        msg
      end
    end

    attr_accessor :id, :change_id, :event_id, :type, :to, :message, :flash,
      :customer_id, :status, :status_date

    def delivered?
      @status == 'DELIVRD'
    end
  end
end
