require "ember-cli/engine" if defined?(Rails)

module EmberCLI
  extend self

  autoload :App,           "ember-cli/app"
  autoload :AssetManifest, "ember-cli/asset_manifest"
  autoload :Configuration, "ember-cli/configuration"
  autoload :Helpers,       "ember-cli/helpers"
  autoload :Middleware,    "ember-cli/middleware"
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

  def prepare!
    @prepared ||= begin
      Rails.configuration.assets.paths << root.join("assets").to_s
      at_exit{ cleanup }
      true
    end
  end

  def enable!
    prepare!
    append_middleware unless env.production?
  end

  def install_dependencies!
    prepare!
    each_app &:install_dependencies
  end

  def run_tests!
    prepare!
    each_app &:run_tests
  end

  def compile!
    prepare!
    each_app &:compile
  end

  def process_path(path)
    each_app{ |app| Runner.new(app, path).process }
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

  def append_middleware
    Rails.configuration.middleware.use Middleware
  end
end
