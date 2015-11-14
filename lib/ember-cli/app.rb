require "non-stupid-digest-assets"
require "ember-cli/html_page"

module EmberCli
  class App
    ADDON_VERSION = "0.0.13"
    EMBER_CLI_VERSIONS = [ "~> 0.1.5", "~> 0.2.0", "~> 1.13" ]

    class BuildError < StandardError; end

    attr_reader :name, :options, :paths, :pid

    delegate :root, to: :paths

    def initialize(name, **options)
      @name, @options = name.to_s, options
      @paths = PathSet.new(
        app: self,
        configuration: EmberCli.configuration,
        environment: Rails.env,
        rails_root: Rails.root,
        ember_cli_root: EmberCli.root,
      )
    end

    def compile
      @compiled ||= begin
        prepare
        silence_build{ exec command }
        check_for_build_error!
        copy_index_html_file
        true
      end
    end

    def install_dependencies
      if paths.gemfile.exist?
        exec "#{paths.bundler} install"
      end

      exec "#{paths.npm} prune && #{paths.npm} install"

      if paths.bower.nil?
        fail <<-FAIL
          Bower is required by EmberCLI

          Install it with:

              $ npm install -g bower
        FAIL
      else
        exec "#{paths.bower} prune && #{paths.bower} install"
      end
    end

    def run
      prepare
      FileUtils.touch paths.lockfile
      cmd = command(watch: true)
      @pid = exec(cmd, method: :spawn)
      Process.detach pid
      copy_index_html_file
      set_on_exit_callback
    end

    def running?
      pid.present? && Process.getpgid(pid)
    rescue Errno::ESRCH
      false
    end

    def run_tests
      prepare

      exec("#{paths.ember} test")
    end

    def stop
      Process.kill :INT, pid if pid
      @pid = nil
    end

    def index_html(sprockets:, head:, body:)
      html_page = HtmlPage.new(
        content: index_file.read,
        head: head,
        body: body,
      )

      html_page.render
    end

    def exposed_js_assets
      [vendor_assets, application_assets]
    end
    alias exposed_css_assets exposed_js_assets

    def vendor_assets
      "#{name}/assets/vendor"
    end

    def application_assets
      "#{name}/assets/#{ember_app_name}"
    end

    def wait
      wait_for_build_complete_or_error
    end

    private

    def set_on_exit_callback
      @on_exit_callback ||= at_exit{ stop }
    end

    def silence_build(&block)
      if ENV.fetch("EMBER_CLI_RAILS_VERBOSE") { EmberCli.env.production? }
        yield
      else
        silence_stream STDOUT, &block
      end
    end

    def watcher
      options.fetch(:watcher) { EmberCli.configuration.watcher }
    end

    def check_for_build_error!
      raise_build_error! if build_error?
    end

    def reset_build_error!
      if build_error?
        paths.build_error_file.delete
      end
    end

    def build_error?
      paths.build_error_file.exist? && paths.build_error_file.size?
    end

    def raise_build_error!
      backtrace = paths.build_error_file.readlines.reject(&:blank?)
      message = "#{name.inspect} has failed to build: #{backtrace.first}"

      error = BuildError.new(message)
      error.set_backtrace(backtrace)

      fail error
    end

    def prepare
      @prepared ||= begin
        check_dependencies!
        check_addon!
        check_ember_cli_version!
        reset_build_error!
        symlink_to_assets_root
        add_assets_to_precompile_list
        true
      end
    end

    def check_ember_cli_version!
      version = dev_dependencies.fetch("ember-cli").split(?-).first

      unless Helpers.match_version?(version, EMBER_CLI_VERSIONS)
        fail <<-MSG.strip_heredoc
          EmberCLI Rails require ember-cli NPM package version to be
          #{EMBER_CLI_VERSIONS.last} to work properly (you have #{version}).
          From within your EmberCLI directory please update your package.json
          accordingly and run:

            $ npm install

        MSG
      end
    end

    def check_addon!
      unless addon_present?
        fail <<-MSG.strip_heredoc
          EmberCLI Rails requires your Ember app to have an addon.

          From within your EmberCLI directory please run:

            $ npm install --save-dev ember-cli-rails-addon@#{ADDON_VERSION}

          in your Ember application root: #{root}
        MSG
      end
    end

    def check_dependencies!
      unless node_modules_present?
        fail <<-MSG.strip_heredoc
          EmberCLI app dependencies are not installed.
          From your Rails application root please run:

            $ bundle exec rake ember:install

        MSG
      end
    end

    def copy_index_html_file
      if environment == "production"
        FileUtils.cp(paths.app_assets.join("index.html"), index_file)
      end
    end

    def index_file
      if environment == "production"
        paths.applications.join("#{name}.html")
      else
        paths.dist.join("index.html")
      end
    end

    def symlink_to_assets_root
      paths.app_assets.make_symlink paths.dist
    rescue Errno::EEXIST
      # Sometimes happens when starting multiple Unicorn workers.
      # Ignoring...
    end

    def add_assets_to_precompile_list
      assets = %r{\A#{name}/}

      Rails.configuration.assets.precompile << assets
      NonStupidDigestAssets.whitelist << assets
    end

    def command(watch: false)
      watch_flag = ""

      if watch
        watch_flag = "--watch"

        if watcher
          watch_flag += " --watcher #{watcher}"
        end
      end

      "#{paths.ember} build #{watch_flag} --environment #{environment} --output-path #{paths.dist} #{redirect_errors} #{log_pipe}"
    end

    def redirect_errors
      "2> #{paths.build_error_file}"
    end

    def log_pipe
      if paths.tee
        "| #{paths.tee} -a #{paths.log}"
      end
    end

    def ember_app_name
      @ember_app_name ||= options.fetch(:name){ package_json.fetch(:name) }
    end

    def environment
      EmberCli.env.production? ? "production" : "development"
    end

    def package_json
      @package_json ||=
        JSON.parse(paths.package_json_file.read).with_indifferent_access
    end

    def addon_package_json
      @addon_package_json ||=
        JSON.parse(paths.addon_package_json_file.read).with_indifferent_access
    end

    def addon_version
      addon_package_json.fetch("version")
    end

    def dev_dependencies
      package_json.fetch("devDependencies", {})
    end

    def addon_present?
      paths.addon_package_json_file.exist? &&
        addon_version == ADDON_VERSION
    end

    def node_modules_present?
      paths.node_modules.exist?
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

    def exec(cmd, method: :system)
      Dir.chdir root do
        Kernel.public_send(method, env_hash, cmd, err: :out) || exit(1)
      end
    end

    def wait_for_build_complete_or_error
      loop do
        check_for_build_error!
        break unless paths.lockfile.exist?
        sleep 0.1
      end
    end
  end
end
