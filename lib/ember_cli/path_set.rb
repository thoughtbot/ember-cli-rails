require "ember_cli/helpers"

module EmberCli
  class PathSet
    def initialize(app:, rails_root:, ember_cli_root:, environment:)
      @app = app
      @rails_root = rails_root
      @environment = environment
      @ember_cli_root = ember_cli_root
    end

    def root
      path = app_options.fetch(:path){ default_root }
      pathname = Pathname.new(path)
      if pathname.absolute?
        pathname
      else
        rails_root.join(path)
      end
    end

    def tmp
      @tmp ||= root.join("tmp").tap(&:mkpath)
    end

    def log
      @log ||= logs.join("ember-#{app_name}.#{environment}.log")
    end

    def dist
      @dist ||= ember_cli_root.join("apps", app_name).tap(&:mkpath)
    end

    def gemfile
      @gemfile ||= root.join("Gemfile")
    end

    def ember
      @ember ||= begin
        root.join("node_modules", ".bin", "ember").tap do |path|
          unless path.executable?
            fail DependencyError.new <<-MSG.strip_heredoc
              No `ember-cli` executable found for `#{app_name}`.

              Install it:

                  $ cd #{root}
                  $ npm install
            MSG
          end
        end
      end
    end

    def lockfile
      @lockfile ||= tmp.join("build.lock")
    end

    def build_error_file
      @build_error_file ||= tmp.join("error.txt")
    end

    def bower
      @bower ||= begin
        bower_path = app_options.fetch(:bower_path) { which("bower") }

        bower_path.tap do |path|
          unless Pathname(path.to_s).executable?
            fail DependencyError.new <<-MSG.strip_heredoc
            Bower is required by EmberCLI

            Install it with:

                $ npm install -g bower
            MSG
          end
        end
      end
    end

    def npm
      @npm ||= app_options.fetch(:npm_path) { which("npm") }
    end

    def tee
      @tee ||= app_options.fetch(:tee_path) { which("tee") }
    end

    def bundler
      @bundler ||= app_options.fetch(:bundler_path) { which("bundler") }
    end

    private

    attr_reader :app, :ember_cli_root, :environment, :rails_root

    def app_name
      app.name
    end

    def app_options
      app.options
    end

    def which(executable)
      Helpers.which(executable)
    end

    def logs
      rails_root.join("log").tap(&:mkpath)
    end

    def default_root
      rails_root.join(app_name)
    end
  end
end
