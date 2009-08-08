begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'smsinabox'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

# Horrible tactics to mock Net::HTTP
def mock_request( params, response_body )
  mock_post = {}
  mock_post.expects(:set_form_data).with(params)
  #mock.expects(:[]=).with('user-agent', anything)

  url = Smsinabox.uri
  Net::HTTP::Post.expects(:new).with( url.path ).returns(mock_post)

  response = Net::HTTPSuccess.new('1.1', 200, 'OK')
  response.instance_variable_set :@body, response_body
  response.instance_variable_set :@read, true

  mock_http = Object.new
  mock_http.expects(:start).returns(response)

  Net::HTTP.expects(:new).with( url.host, url.port ).returns(mock_http)
end
