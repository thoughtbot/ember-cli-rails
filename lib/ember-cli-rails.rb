require "ember-cli/railtie" if defined?(Rails)

module EmberCLI
  extend self

  autoload :App,           "ember-cli/app"
  autoload :Configuration, "ember-cli/configuration"
  autoload :ViewHelpers,   "ember-cli/view_helpers"
  autoload :Helpers,       "ember-cli/helpers"

  def configure
    yield configuration
  end

  def configuration
    Configuration.instance
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

    Rails.application.singleton_class.class_eval do
      alias_method :call_without_ember_cli, :call

      def call(env)
        @_ember_cli_enabled ||= begin
          EmberCLI.compile!
          EmberCLI.run! if Rails.env.development?
          true
        end

        call_without_ember_cli(env)
      end
    end
  end

  def run!
    prepare!
    each_app &:run
  end

  def compile!
    prepare!
    each_app &:compile
  end

  def stop!
    each_app &:stop
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

  def each_app
    configuration.apps.each{ |name, app| yield app }
  end
end
