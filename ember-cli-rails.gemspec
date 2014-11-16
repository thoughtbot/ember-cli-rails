require_relative "./lib/ember-cli/version"

Gem::Specification.new do |spec|
  spec.name     = "ember-cli-rails"
  spec.version  = EmberCLI::VERSION
  spec.authors  = ["Pavel Pravosud"]
  spec.email    = ["pavel@pravosud.com"]
  spec.summary  = "Helps integrate EmberCLI with Rails"
  spec.homepage = "https://github.com/rwz/ember-cli-rails"
  spec.license  = "MIT"
  spec.files    = Dir["README.md", "LICENSE.txt", "lib/**/*"]

  spec.required_ruby_version = "~> 2.0"
  spec.add_dependency "railties", "~> 4.0"
end
