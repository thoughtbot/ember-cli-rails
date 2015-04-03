module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      unless skip_middleware?
        enable_ember_cli
        EmberCLI.wait!
      end

      if env["PATH_INFO"] == "/testem.js"
        [ 200, { "Content-Type" => "text/javascript" }, [""] ]
      else
        @app.call(env)
      end
    end

    private

    def skip_middleware?
      %r{/api/}.match(env["REQUEST_URI"])
    end

    def enable_ember_cli
      @enabled ||= begin
        if EmberCLI.env.development?
          EmberCLI.run!
        else
          EmberCLI.compile!
        end

        true
      end
    end
  end
end
