require "cocaine"

module EmberCli
  class Command
    def initialize(paths:, options: {})
      @paths = paths
      @options = options
    end

    def test
      line = Cocaine::CommandLine.new(paths.ember, "test --environment test")

      line.command
    end

    def build(watch: false)
      [
        build_command(watch: watch),
        pipe_to_logs_command,
      ].compact.join(" | ")
    end

    private

    attr_reader :options, :paths

    def pipe_to_logs_command
      unless paths.tee.nil?
        line = Cocaine::CommandLine.new(paths.tee, "-a :log_file")

        line.command(log_file: paths.log)
      end
    end

    def build_command(watch: false)
      line = Cocaine::CommandLine.new(paths.ember, [
        "build",
        ("--watch" if watch),
        ("--watcher :watcher" if process_watcher),
        "--environment :environment",
        "--output-path :output_path",
        "2> :error_file",
      ].compact.join(" "))

      line.command(
        environment: build_environment,
        output_path: paths.dist,
        watcher: process_watcher,
        error_file: paths.build_error_file,
      )
    end

    def process_watcher
      options.fetch(:watcher) { EmberCli.configuration.watcher }
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
