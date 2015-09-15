module EmberCLI
  class Runner
    TRUE_PROC = ->(*){ true }

    attr_reader :app, :env

    def initialize(app, env)
      @app, @env = app, env
    end

    def process
      return if skip?

      if EmberCLI.env.development?
        start_or_restart!
      else
        compile!
      end

      wait!
    end

    private

    def path
      env["PATH_INFO"].to_s
    end

    def skip?
      invoker = app.options.fetch(:enable, TRUE_PROC)

      if invoker.arity == 2
        enabled = invoker.call(path, env)
      else
        enabled = invoker.call(path)
      end

      !enabled
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
