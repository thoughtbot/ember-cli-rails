require File.expand_path("../lib/ember-cli/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name     = "ember-cli-rails"
  spec.version  = EmberCli::VERSION.dup
  spec.authors  = ["Pavel Pravosud", "Jonathan Jackson", "Sean Doyle"]
  spec.email    = ["pavel@pravosud.com", "jonathan.jackson1@me.com", "sean.p.doyle24@gmail.com"]
  spec.summary  = "Integration between Ember CLI and Rails"
  spec.homepage = "https://github.com/thoughtbot/ember-cli-rails"
  spec.license  = "MIT"
  spec.files    = Dir["README.md", "CHANGELOG.md", "LICENSE.txt", "{lib,app,config}/**/*"]

  spec.required_ruby_version = ">= 2.1.0"

  spec.add_dependency "railties", ">= 3.2", "< 5"
  spec.add_dependency "non-stupid-digest-assets", "~> 1.0.0"
  spec.add_dependency "sprockets", ">= 2.0"
end
