require "ember-cli/railtie" if defined?(Rails)

module EmberCLI
  extend self

  autoload :App,           "ember-cli/app"
  autoload :Configuration, "ember-cli/configuration"
  autoload :RackServer,    "ember-cli/rack_server"
  autoload :ViewHelpers,   "ember-cli/view_helpers"
  autoload :Helpers,       "ember-cli/helpers"

  def configure
    yield configuration
  end

  def configuration
    Configuration.instance
  end

  def prepare!
    Rack::Server.send :prepend, RackServer
    Rails.configuration.assets.paths << root.join("assets").to_s
    at_exit{ cleanup }
  end

  def start!
    configuration.apps.values.each(&:start)
  end

  def stop!
    configuration.apps.values.each(&:stop)
  end

  def root
    @root ||= Rails.root.join("tmp", "ember-cli-#{uid}")
  end

  private

  def uid
    @uid ||= SecureRandom.uuid
  end

  def cleanup
    root.rmtree if root.exist?
  end
end
