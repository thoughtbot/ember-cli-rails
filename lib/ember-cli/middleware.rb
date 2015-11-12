module EmberCli
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.path_info == "/testem.js"
        [ 200, { "Content-Type" => "text/javascript" }, [""] ]
      else
        EmberCLI.process_request(request)
        @app.call(env)
      end
    end
  end
end
