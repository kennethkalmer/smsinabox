require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Smsinabox" do
  
  it "should accept a username" do
    Smsinabox.username = 'test'
    Smsinabox.username.should eql('test')
  end
  
  it "should accept a password" do
    Smsinabox.password = 'test'
    Smsinabox.password.should eql('test')
  end
  
end
