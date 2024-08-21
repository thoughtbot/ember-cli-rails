source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "7.2")

if rails_version == "main"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "ember-cli-rails-assets", github: "seanpdoyle/ember-cli-rails-assets" if rails_version == "main" || Gem::Version.new(rails_version) >= Gem::Version.new("7.0")
gem "high_voltage", "~> 3.0.0"
gem "webdrivers", "~> 5.0"
gem "webrick"
