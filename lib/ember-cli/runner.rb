require "ember-cli/build_constraint"

module EmberCli
  class Runner
    attr_reader :app, :request

    def initialize(app, request)
      @app = app
      @request = request
    end

    def process
      return unless build.enabled?

      if EmberCli.env.development?
        start_or_restart!
      else
        compile!
      end

      wait!
    end

    private

    def build
      BuildConstraint.new(
        request: request,
        block: app.options[:enabled],
      )
    end

    def start_or_restart!
      run! unless app.pid && still_running?
    end

    def still_running?
      Process.getpgid app.pid
      true
    rescue Errno::ESRCH # no such process
      false
    end

    def wait!
      app.wait
    end

    def compile!
      app.compile
    end

    def run!
      app.run
    end
  end
end
