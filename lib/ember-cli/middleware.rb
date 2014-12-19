module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
      @ember_apps_started = {}
    end

    def call(env)
      request = Rack::Request.new(env)
      check_ember request
      @app.call env
    end

    private

    def check_ember(request)
      return unless request.get?

      if app_name = request.fullpath[ember_assets_path, 1]
        app = ember_apps.fetch(app_name)
        prepare_ember_app app
        app.wait
      end
    end

    def prepare_ember_app(app)
      return if @ember_apps_started[app.name]
      @ember_apps_started.store app.name, true

      if Rails.env.development?
        app.run
      else
        app.compile
      end
    end

    def ember_assets_path
      @ember_assets_path ||= begin
        prefix = Rails.configuration.assets.prefix
        ember_apps_names = Regexp.union(*ember_apps.keys)

        Regexp.new("\\A#{prefix}\/(#{ember_apps_names})\/.+")
      end
    end

    def ember_apps
      EmberCLI.configuration.apps
    end
  end
end
