Gem::Specification.new do |s|
  s.name = %q{smsinabox}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kenneth Kalmer"]
  s.date = %q{2008-09-25}
  s.description = %q{Ruby API for the SMS in a Box service, as well as command line utilities for interacting with SMS in a Box}
  s.email = ["kenneth.kalmer@gmail.com"]
  s.executables = ["sms-credit", "sms-send", "sms-setup"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "TODO.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "TODO.txt", "bin/sms-credit", "bin/sms-send", "bin/sms-setup", "config/hoe.rb", "config/requirements.rb", "lib/smsinabox.rb", "lib/smsinabox/configuration.rb", "lib/smsinabox/exceptions.rb", "lib/smsinabox/message.rb", "lib/smsinabox/version.rb", "script/console", "script/destroy", "script/generate", "setup.rb", "smsinabox.gemspec", "spec/message_spec.rb", "spec/smsinabox_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/rspec.rake", "tasks/website.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://www.opensourcery.co.za/smsinabox}
  s.post_install_message = %q{
For more information on smsinabox, see http://www.opensourcery.co.za/smsinabox

Setup your account by running sms-setup now. You can then use the following
commands to interact with SMS in a Box:

sms-send: Send SMS messages
sms-credit: Quick overview of the credit available
sms-replies: Quick access to your replies
sms-setup: To change the account details
}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{smsinabox}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Ruby API for the SMS in a Box service, as well as command line utilities for interacting with SMS in a Box}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
