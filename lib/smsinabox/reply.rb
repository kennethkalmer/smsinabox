module Smsinabox
  class Reply

    class << self

      # Generate a reply from the nokogiri response fragment
      def from_response( nokogiri_xml )
        reply = new

        reply.id = nokogiri_xml.xpath('./replyid/text()').to_s.to_i
        reply.event_id = nokogiri_xml.xpath('./eventid/text()').to_s.to_i
        reply.from = nokogiri_xml.xpath('./numfrom/text()').to_s
        reply.message = nokogiri_xml.xpath('./receiveddata/text()').to_s
        reply.sent_id = nokogiri_xml.xpath('./sentid/text()').to_s.to_i
        reply.original = nokogiri_xml.xpath('./sentdata/text()').to_s
        reply.sent_customer_id = nokogiri_xml.xpath('./sentcustomerid/text()').to_s
        reply.received = nokogiri_xml.xpath('./received/text()').to_s
        reply.sent = nokogiri_xml.xpath('./sentdatetime/text()').to_s

        reply
      end
    end

    attr_accessor :id, :event_id, :from, :message, :sent_id, :original,
      :sent_customer_id, :received, :sent
  end
end
