source "https://rubygems.org"

gemspec

gem "appraisal"
gem "rails", "4.2.4"
gem "pry"

if RUBY_ENGINE == "jruby"
  gem "json-jruby"
end

group :development, :test do
  gem "high_voltage", "~> 3.0.0"
  gem "rspec-rails", "~> 3.5.0"
end

group :test do
  gem "poltergeist", "~> 1.8.0"
  gem "codeclimate-test-reporter", require: nil
end
