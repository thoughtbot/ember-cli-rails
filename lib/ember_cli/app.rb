require "html_page/renderer"
require "ember_cli/path_set"
require "ember_cli/shell"
require "ember_cli/build_monitor"
require "ember_cli/deploy/file"

module EmberCli
  class App
    attr_reader :name, :options, :paths

    def initialize(name, **options)
      @name = name.to_s
      @options = options
      @paths = PathSet.new(
        app: self,
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

    def root_path
      paths.root
    end

    def dist_path
      paths.dist
    end

    def config_environment_path
      root_path.join("config", "environment.js")
    end

    def cached_directories
      paths.cached_directories
    end

    def compile
      @compiled ||= begin
        prepare
        exit_status = @shell.compile
        @build.check!

        exit_status.success?
      end
    end

    def build
      unless EmberCli.skip?
        if development?
          build_and_watch
        elsif test?
          compile
        end

        @build.wait!
      end
    end

    def index_html(head:, body:)
      html = HtmlPage::Renderer.new(
        head: head,
        body: body,
        content: deploy.index_html,
      )

      html.render
    end

    def install_dependencies
      @shell.install
    end

    def test
      prepare

      @shell.test.success?
    end

    def check_for_errors!
      @build.check!
    end

    def mountable?
      deploy.mountable?
    end

    def yarn_enabled?
      options.fetch(:yarn, false)
    end

    def bower?
      paths.bower_json.exist?
    end

    def to_rack
      deploy.to_rack
    end

    def update_test_env_configuration(mirage: false)
      mirage.present? ? update_with_mirage : update_without_mirage
    end

    private

    def update_without_mirage
      tmp = StringIO.open
      File.open(config_environment_path, "r") do |f|
        f.each_line { |line| tmp = replace_common_config(line, tmp) }
      end
      write_config_file(tmp)
    end

    def update_with_mirage
      tmp = StringIO.open
      File.open(config_environment_path, "r") do |f|
        f.each_line do |line|
          tmp = replace_common_config(line, tmp)
          tmp = add_mirage_test_config_if_needed(line, tmp)
        end
      end
      write_config_file(tmp)
    end

    def replace_common_config(line, tmp)
      content = if line["ENV.locationType = 'none'"]
                  "    ENV.locationType = typeof process.env.RAILS_ENV"\
                  " === 'undefined' ? 'none' : ENV.locationType;"
                elsif line["ENV.APP.rootElement = '#ember-testing'"]
                  "    ENV.APP.rootElement = typeof process.env.RAILS_ENV"\
                  " === 'undefined' ? '#ember-testing' : ENV.rootElement;"
                else
                  line
                end
      tmp.puts(content)
      tmp
    end

    def add_mirage_test_config_if_needed(line, tmp)
      if line["if (environment === 'test') {"]
        mirage_condition_already_added = IO.read(config_environment_path)[
          "if (environment === 'test') {\n    ENV['ember-cli-mirage'] ="
        ]
        unless mirage_condition_already_added
          content = "    ENV['ember-cli-mirage'] = { enabled: typeof "\
                    "process.env.RAILS_ENV === 'undefined' };"
          tmp.puts(content)
        end
      end
      tmp
    end

    def write_config_file(stream)
      stream.seek(0)
      File.open(config_environment_path, "w") { |f| f.puts(stream.read) }
    end

    def development?
      env.to_s == "development"
    end

    def test?
      env.to_s == "test"
    end

    def deploy
      deploy_strategy.new(self)
    end

    def deploy_strategy
      strategy = options.fetch(:deploy, {})

      if strategy.respond_to?(:fetch)
        strategy.fetch(rails_env, EmberCli::Deploy::File)
      else
        strategy
      end
    end

    def rails_env
      Rails.env.to_s.to_sym
    end

    def env
      EmberCli.env
    end

    def build_and_watch
      prepare
      @shell.build_and_watch
    end

    def prepare
      @prepared ||= begin
        @build.reset
        true
      end
    end

    def excluded_ember_deps
      Array.wrap(options[:exclude_ember_deps]).join("?")
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
