require './lib/smsinabox'

Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'smsinabox'
    gemspec.version = Smsinabox::VERSION
    gemspec.summary = 'Ruby API for sending text messages via http://www.smsinabox.co.za'
    gemspec.description = 'Ruby API for sending text messages via http://www.smsinabox.co.za'
    gemspec.email = 'kenneth.kalmer@gmail.com'
    gemspec.homepage = 'http://github.com/kennethkalmer/smsinabox'
    gemspec.authors = ['kenneth.kalmer@gmail.com']
    gemspec.post_install_message = IO.read('PostInstall.txt')
    gemspec.extra_rdoc_files.include '*.txt'

    gemspec.add_dependency 'nokogiri', '>= 1.3.3'
    gemspec.add_development_dependency 'rspec'
    gemspec.add_development_dependency 'cucumber'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with 'gem install jeweler'"
end
