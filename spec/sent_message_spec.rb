require File.dirname(__FILE__) + '/spec_helper'

describe Smsinabox::SentMessage do
  before(:each) do
    xml = <<-EOF
    <api_result>
    <data>
    <changeid>26053853</changeid>
    <sentid>339611089</sentid>
    <eventid>33369735</eventid>
    <smstype>SMS</smstype>
    <numto>27123456789</numto>
    <data>Foo</data>
    <flash>false</flash>
    <customerid/>
    <status>DELIVRD</status>
    <statusdate>07/Aug/2009 14:13:44</statusdate>
    </data>
    </api_result>
    EOF

    @xml_response = Nokogiri::XML( xml )
  end

  it "should parse the sent message from the response" do
    sent = Smsinabox::SentMessage.from_response( @xml_response.xpath('/api_result/data').first )

    sent.id.should == 339611089
    sent.change_id.should == 26053853
    sent.event_id.should == 33369735
    sent.type.should == 'SMS'
    sent.to.should == '27123456789'
    sent.message.should == 'Foo'
    sent.flash.should be_false
    sent.customer_id.should == ''
    sent.status.should == 'DELIVRD'
    sent.should be_delivered
    sent.status_date.should == '07/Aug/2009 14:13:44'
  end
end
