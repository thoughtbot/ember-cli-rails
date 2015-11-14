module EmberCli
  class Runner
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def run!
      if EmberCli.env.development?
        start_or_restart!
      else
        app.compile
      end

      app.wait
    end

    private

    def start_or_restart!
      unless app.running?
        app.run
      end
    end
  end
end
