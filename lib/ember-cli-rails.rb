require "ember_cli/engine" if defined?(Rails)
require "ember_cli/errors"

module EmberCli
  extend self

  autoload :App,           "ember_cli/app"
  autoload :Configuration, "ember_cli/configuration"
  autoload :Helpers,       "ember_cli/helpers"
  autoload :PathSet,       "ember_cli/path_set"

  def configure
    yield configuration
  end

  def configuration
    Configuration.instance
  end

  def app(name)
    apps.fetch(name) do
      fail KeyError, "#{name.inspect} app is not defined"
    end
  end

  alias_method :[], :app

  def skip?
    ENV["SKIP_EMBER"].present?
  end

  def enable!
    @enabled ||= begin
      Rails.configuration.assets.paths << root.join("assets").to_s
      at_exit{ cleanup }
      true
    end
  end

  def install_dependencies!
    enable!
    each_app(&:install_dependencies)
  end

  def test!
    enable!
    each_app(&:test)
  end

  def compile!
    enable!
    each_app(&:compile)
  end

  def root
    @root ||= Rails.root.join("tmp", "ember-cli-#{uid}")
  end

  def env
    @env ||= Helpers.current_environment.inquiry
  end

  delegate :apps, to: :configuration

  private

  def uid
    @uid ||= SecureRandom.uuid
  end

  def cleanup
    root.rmtree if root.exist?
  end

  def each_app
    apps.each { |_, app| yield app }
  end
end

EmberCLI = EmberCli
