require File.dirname(__FILE__) + '/spec_helper'

describe Smsinabox::Reply do
  before(:each) do
    xml = <<-EOF
    <api_result>
    <data>
    <replyid>3903103</replyid>
    <eventid>33368123</eventid>
    <numfrom>27123456789</numfrom>
    <receiveddata>Bar</receiveddata>
    <sentid>339548269</sentid>
    <sentdata>Foo</sentdata>
    <sentcustomerid/>
    <received>10/Aug/2009 00:09:46</received>
    <sentdatetime>07/Aug/2009 13:51:48</sentdatetime>
    </data>
    </api_result>
    EOF
    @xml_reply = Nokogiri::XML( xml )
  end

  it "should parse from response data" do
    reply = Smsinabox::Reply.from_response( @xml_reply.xpath('/api_result/data').first )

    reply.id.should == 3903103
    reply.event_id.should == 33368123
    reply.from.should == '27123456789'
    reply.message.should == 'Bar'
    reply.sent_id.should == 339548269
    reply.original.should == 'Foo'
    reply.sent_customer_id.should == ''
    reply.received.should == '10/Aug/2009 00:09:46'
    reply.sent.should == '07/Aug/2009 13:51:48'
  end
end
