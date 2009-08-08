require File.dirname(__FILE__) + '/spec_helper'

describe Smsinabox::DeliveryReport do
  before(:each) do
    f = File.open( File.dirname(__FILE__) + '/fixtures/sendparam_response.xml' )
    sample_response = Nokogiri::XML( f )

    @report = Smsinabox::DeliveryReport.from_response( sample_response )
  end

  it "should have an event id" do
    @report.event_id.should be(27105067)
  end

  it "should have credits" do
    @report.credits.should be(39763)
  end

  it "should know how many failed" do
    @report.fail_count.should be(1)
  end

  it "should know how many succeeded" do
    @report.success_count.should be(3)
  end

  it "should have a list of failures" do
    @report.failures.should_not be_empty

    f = @report.failures.first
    f.should == { :numto => '', :customerid => '', :reason => 'numto invalid' }
  end

  it "should have a list of successes" do
    @report.successes.should_not be_empty

    s = @report.successes.first
    s.should == { :numto => '27832297941', :customerid => 'UnqiueValue1' }
  end
end
