source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "6.0")

if rails_version == "master"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "ember-cli-rails-assets", github: "seanpdoyle/ember-cli-rails-assets" if Gem::Version.new(rails_version) >= Gem::Version.new("7.0")
gem "high_voltage", "~> 3.0.0"
gem "rexml" # For selenium-webdriver on Ruby 3.0.0. This is required until selenium-webdriver 4 is released. https://github.com/SeleniumHQ/selenium/pull/9007
gem "webdrivers", "~> 4.0"
gem "webrick"
