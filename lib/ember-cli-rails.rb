require "ember-cli/engine" if defined?(Rails)

module EmberCli
  class DependencyError < StandardError; end

  extend self

  autoload :App,           "ember-cli/app"
  autoload :Configuration, "ember-cli/configuration"
  autoload :Helpers,       "ember-cli/helpers"
  autoload :PathSet,       "ember-cli/path_set"
  autoload :Runner,        "ember-cli/runner"

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
    each_app &:install_dependencies
  end

  def run_tests!
    enable!
    each_app &:run_tests
  end

  def compile!
    enable!
    each_app &:compile
  end

  def run!
    each_app { |app| Runner.new(app).run! }
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
    apps.each{ |name, app| yield app }
  end
end

EmberCLI = EmberCli
