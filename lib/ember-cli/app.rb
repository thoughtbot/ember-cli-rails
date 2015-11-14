require "ember-cli/shell"
require "ember-cli/sprockets"
require "ember-cli/build_monitor"

module EmberCli
  class App
    attr_reader :name, :options, :paths

    def initialize(name, **options)
      @name = name.to_s
      @options = options
      @paths = PathSet.new(
        app: self,
        configuration: EmberCli.configuration,
        environment: Rails.env,
        rails_root: Rails.root,
        ember_cli_root: EmberCli.root,
      )
      @shell = Shell.new(
        paths: @paths,
        env: env_hash,
        options: options,
      )
      @build = BuildMonitor.new(name, @paths)
    end

    def compile
      @compiled ||= begin
        prepare
        @shell.compile
        @build.check!
        copy_index_html_file
        true
      end
    end

    def build
      if EmberCli.env.development?
        build_and_watch
      else
        compile
      end

      @build.wait!
    end

    def install_dependencies
      @shell.install
    end

    def test
      prepare

      @shell.test
    end

    def sprockets
      EmberCli::Sprockets.new(self)
    end

    def index_file
      if EmberCli.env.production?
        paths.applications.join("#{name}.html")
      else
        paths.dist.join("index.html")
      end
    end

    private

    def build_and_watch
      prepare
      @shell.build_and_watch
      copy_index_html_file
    end

    def prepare
      @prepared ||= begin
        @build.reset
        symlink_to_assets_root
        sprockets.register!
        true
      end
    end

    def copy_index_html_file
      if EmberCli.env.production?
        FileUtils.cp(paths.app_assets.join("index.html"), index_file)
      end
    end

    def symlink_to_assets_root
      paths.app_assets.make_symlink paths.dist
    rescue Errno::EEXIST
      # Sometimes happens when starting multiple Unicorn workers.
      # Ignoring...
    end

    def excluded_ember_deps
      Array.wrap(options[:exclude_ember_deps]).join(?,)
    end

    def env_hash
      ENV.to_h.tap do |vars|
        vars["RAILS_ENV"] = Rails.env
        vars["EXCLUDE_EMBER_ASSETS"] = excluded_ember_deps
        vars["BUNDLE_GEMFILE"] = paths.gemfile.to_s if paths.gemfile.exist?
      end
    end
  end
end
