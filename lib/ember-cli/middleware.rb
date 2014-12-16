module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      apps.map(&:lock)
      @app.call(env)
    end

    private

    def apps
      EmberCLI.configuration.apps.values
    end
  end
end
