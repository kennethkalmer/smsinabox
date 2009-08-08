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

  it "should be able to deliver sms notifications" do
    mock_request(
      has_entries({ 'Type' => 'sendparam', 'Username' => 'test', 'Password' => 'test', 'numto' => '0123456789', 'data1' => 'Foo' }),
      "<api_result><send_info><eventid>1</eventid><credits>1</credits><msgs_success>1</msgs_success></send_info><entries_success><numto>0123456789</numto></entries_success></api_result>"
    )

    sms = Smsinabox::SMS.new( :recipient => '0123456789', :body => 'Foo')
    res = Smsinabox.deliver( sms )

    res.should be_a( Smsinabox::DeliveryReport )
    res.success_count.should be(1)
  end
end
