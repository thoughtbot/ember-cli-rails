require "fileutils"
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

  def build(name)
    app(name).build
  end

  alias_method :[], :app

  def skip?
    ENV["SKIP_EMBER"].present?
  end

  def install_dependencies!
    each_app(&:install_dependencies)
  end

  def test!
    each_app(&:test)
  end

  def compile!
    cleanup!
    each_app(&:compile)
  end

  def root
    @root ||= Rails.root.join("tmp", "ember-cli").tap(&:mkpath)
  end

  def env
    @env ||= Helpers.current_environment.inquiry
  end

  delegate :apps, to: :configuration

  private

  def cleanup!
    root.children.each { |tmp_file| FileUtils.rm_rf(tmp_file) }
  end

  def each_app
    apps.each { |_, app| yield app }
  end
end

EmberCLI = EmberCli
