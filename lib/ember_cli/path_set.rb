module EmberCli
  class PathSet
    def initialize(app:, rails_root:, ember_cli_root:, environment:, configuration:)
      @app = app
      @configuration = configuration
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

    def asset_map
      @asset_map ||= Pathname.glob(assets.join("assetMap*.json")).first
    end

    def assets
      @assets ||= dist.join("assets").tap(&:mkpath)
    end

    def gemfile
      @gemfile ||= root.join("Gemfile")
    end

    def package_json_file
      @package_json_file ||= root.join("package.json")
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
        bower_path = app_options.fetch(:bower_path) { configuration.bower_path }

        bower_path.tap do |path|
          unless Pathname(path).executable?
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
      @npm ||= app_options.fetch(:npm_path) { configuration.npm_path }
    end

    def bundler
      @bundler ||= app_options.fetch(:bundler_path) do
        configuration.bundler_path
      end
    end

    private

    attr_reader :app, :configuration, :ember_cli_root, :environment, :rails_root

    delegate :name, :options, to: :app, prefix: true

    def logs
      rails_root.join("log").tap(&:mkpath)
    end

    def default_root
      rails_root.join(app_name)
    end
  end
end
