require File.dirname(__FILE__) + '/spec_helper.rb'

describe Smsinabox, "configuration" do

  it "should have a default base URI" do
    Smsinabox.uri.to_s.should == "http://www.mymobileapi.com/api5/http5.aspx"
  end

  it "should accept a username" do
    Smsinabox.username = 'test'
    Smsinabox.username.should eql('test')
  end

  it "should accept a password" do
    Smsinabox.password = 'test'
    Smsinabox.password.should eql('test')
  end

end

describe Smsinabox do
  before do
    Smsinabox.username = 'test'
    Smsinabox.password = 'test'
  end

  it "should know how much credit is available" do
    #response = Object.new
    #response.expects(:body).returns("<api_result><data><credits>0</credits></data><call_result><result>True</result><error /></call_result></api_result>")
    #Net::HTTP.expects(:post_form).with( Smsinabox.uri, { :Type => 'credits', :Username => 'test', :Password => 'test'} ).returns( response )
    mock_request(
      {'Type' => 'credits', 'Username' => 'test', 'Password' => 'test'},
      "<api_result><data><credits>0</credits></data><call_result><result>True</result><error /></call_result></api_result>"
    )

    Smsinabox.credit_remaining.should be(0)
  end

  it "should be able to deliver SMS-type messages" do
    mock_request(
      has_entries({ 'Type' => 'sendparam', 'Username' => 'test', 'Password' => 'test', 'numto' => '0123456789', 'data1' => 'Foo' }),
      "<api_result><send_info><eventid>1</eventid><credits>1</credits><msgs_success>1</msgs_success></send_info><entries_success><numto>0123456789</numto></entries_success></api_result>"
    )

    sms = Smsinabox::SMS.new( :recipient => '0123456789', :body => 'Foo')
    res = Smsinabox.deliver( sms )

    res.should be_a( Smsinabox::DeliveryReport )
    res.success_count.should be(1)
  end

  it "should be able to retrieve replies" do
    mock_request(
      has_entries({'Type' => 'replies', 'Username' => 'test', 'Password' => 'test', 'XMLData' => "<reply><settings><id>0</id><max_recs>100</max_recs><cols_returned>eventid,numfrom,receiveddata,received,sentid,sentdata,sentdatetime,sentcustomerid</cols_returned></settings></reply>"}),
      "<api_result><data><replyid></replyid><eventid></eventid><numfrom>0123456789</numfrom><receiveddata>Bar</receiveddata><sentid></sentid><sentdata>Foo</sentdata><sentcustomerid/><received></received><senddatetime></senddatetime></data></api_result>"
    )

    Smsinabox.replies do |reply|
      reply.should be_a( Smsinabox::Reply )
      reply.from.should == '0123456789'
      reply.message.should == 'Bar'
      reply.original.should == 'Foo'
    end
  end

  it "should be able to retrieve sent data" do
    mock_request(
      has_entries({'Type' => 'sent', 'Username' => 'test', 'Password' => 'test', 'XMLData' => "<sent><settings><id>0</id><max_recs>100</max_recs><cols_returned>sentid,eventid,smstype,numto,data,flash,customerid,status,statusdate</cols_returned></settings></sent>"}),
      "<api_result><data><changeid></changeid><sentid></sentid><eventid></eventid><smstype>SMS</smstype><numto>0123456789</numto><data>Foo</data><flash>false</flash><customerid/><status>DELIVRD</status><statusdate></statusdate></data></api_result>"
    )

    results = Smsinabox.sent
    results.size.should == 1

    item = results.first
    item.to.should == '0123456789'
    item.message.should == 'Foo'
    item.type.should == 'SMS'
  end
end
