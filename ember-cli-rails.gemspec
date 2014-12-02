require_relative "./lib/ember-cli/version"

Gem::Specification.new do |spec|
  spec.name     = "ember-cli-rails"
  spec.version  = EmberCLI::VERSION
  spec.authors  = ["Pavel Pravosud", "Jonathan Jackson"]
  spec.email    = ["pavel@pravosud.com", "jonathan.jackson1@me.com"]
  spec.summary  = "Integration between Ember CLI and Rails"
  spec.homepage = "https://github.com/rwz/ember-cli-rails"
  spec.license  = "MIT"
  spec.files    = Dir["README.md", "LICENSE.txt", "lib/**/*"]

  spec.required_ruby_version = "~> 2.0"
  spec.add_dependency "railties", "~> 4.0"
end
