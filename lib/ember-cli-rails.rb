require "ember-cli/railtie" if defined?(Rails)

module EmberCLI
  extend self

  autoload :BuildServer,   "ember-cli/build_server"
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
    Rack::Server.prepend RackServer
    Rails.configuration.assets.paths << root.join("assets").to_s
    at_exit{ cleanup }
  end

  def start!
    configuration.app_list.each(&:start)
  end

  def stop!
    configuration.app_list.each(&:stop)
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
