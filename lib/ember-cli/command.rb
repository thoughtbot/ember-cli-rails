module EmberCli
  class Command
    def initialize(paths:, options: {})
      @paths = paths
      @options = options
    end

    def test
      "#{paths.ember} test"
    end

    def build(watch: false)
      [
        "#{paths.ember} build",
        "#{watch_flag(watch)}",
        "--environment #{build_environment}",
        "--output-path #{paths.dist}",
        pipe_errors_to_file,
        pipe_to_log_files,
      ].join(" ")
    end

    private

    attr_reader :options, :paths

    def process_watcher
      options.fetch(:watcher) { EmberCli.configuration.watcher }
    end

    def watch_flag(watch)
      watch_flag = ""

      if watch
        watch_flag = "--watch"

        if process_watcher
          watch_flag += " --watcher #{process_watcher}"
        end
      end

      watch_flag
    end

    def pipe_errors_to_file
      "2> #{paths.build_error_file}"
    end

    def pipe_to_log_files
      if paths.tee
        "| #{paths.tee} -a #{paths.log}"
      end
    end

    def build_environment
      if EmberCli.env == "production"
        "production"
      else
        "development"
      end
    end
  end
end
