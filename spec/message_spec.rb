require File.dirname(__FILE__) + '/spec_helper.rb'

describe Smsinabox::Message do
  
  it "should accept a recipient" do
    message = Smsinabox::Message.new( :recipient => '5555555555' )
    message.recipient.should eql('5555555555')
    
    message = Smsinabox::Message.new
    message.recipient = '5555555555'
    message.recipient.should eql('5555555555')
  end
  
  it "should accept a body" do
    message = Smsinabox::Message.new( :body => 'text' )
    message.body.should eql('text')
    
    message = Smsinabox::Message.new
    message.body = 'text'
    message.body.should eql('text')
  end
  
  it "should only be valid if both the recipient and body is set" do
    message = Smsinabox::Message.new
    message.should_not be_valid
    
    message.recipient = '5555555555'
    message.should_not be_valid
    
    message.body = 'text'
    message.should be_valid
    
    message.recipient = nil
    message.should_not be_valid
  end
  
  it "should replace newlines with pipe (|) characters" do
    message = Smsinabox::Message.new
    message.body = <<-EOF
    This
    needs
    pipes
    EOF

    message.body.should match( /This|\s+needs|\s+pipes/ )
  end
end
