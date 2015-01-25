module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      enable_ember_cli
      EmberCLI.wait!

      @app.call(env)
    end

    private

    def enable_ember_cli
      @enabled ||= begin
        if Helpers.use_live_recompilation?
          EmberCLI.run!
        else
          EmberCLI.compile!
        end

        true
      end
    end
  end
end
