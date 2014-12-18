require "timeout"

module EmberCLI
  class App
    ADDON_VERSION = "0.0.3"

    attr_reader :name, :options, :pid

    def initialize(name, options={})
      @name, @options = name.to_s, options
    end

    def compile
      prepare
      silence_stream STDOUT do
        system command, chdir: app_path, err: :out
      end
    end

    def run
      prepare
      @pid = spawn(command(watch: true), chdir: app_path, err: :out)
      at_exit{ stop }
    end

    def stop
      Process.kill "INT", pid if pid
      @pid = nil
    end

    def exposed_js_assets
      %W[#{name}/vendor #{name}/#{ember_app_name}]
    end

    def exposed_css_assets
      %W[#{name}/vendor #{name}/#{ember_app_name}]
    end

    def wait
      Timeout.timeout(build_timeout) do
        sleep 0.1 while lockfile.exist?
      end
    rescue Timeout::Error
      suggested_timeout = build_timeout + 5

      warn <<-MSG.strip_heredoc
        ============================= WARNING! =============================

          Seems like Ember #{name} application takes more than #{build_timeout}
          seconds to compile.

          To prevent race conditions consider adjusting build timeout
          configuration in your ember initializer:

            EmberCLI.configure do |config|
              config.build_timeout = #{suggested_timeout} # in seconds
            end

          Alternatively, you can set build timeout per application like this:

            EmberCLI.configure do |config|
              config.app :#{name}, build_timeout: #{suggested_timeout}
            end

        ============================= WARNING! =============================
      MSG
    end

    private

    delegate :ember_path, to: :configuration
    delegate :tee_path, to: :configuration
    delegate :configuration, to: :EmberCLI

    def build_timeout
      options.fetch(:build_timeout){ configuration.build_timeout }
    end

    def lockfile
      app_path.join("tmp", "build.lock")
    end

    def prepare
      @prepared ||= begin
        check_addon!
        FileUtils.touch lockfile
        symlink_to_assets_root
        add_assets_to_precompile_list
        true
      end
    end

    def check_addon!
      dependencies = package_json.fetch("devDependencies", {})

      unless dependencies["ember-cli-rails-addon"] == ADDON_VERSION
        fail <<-MSG.strip_heredoc
          EmberCLI Rails requires your Ember app to have an addon.

          Please run:

            $ npm install --save-dev ember-cli-rails-addon@#{ADDON_VERSION}`

          in you Ember application root: #{app_path}
        MSG
      end
    end

    def symlink_to_assets_root
      symlink_path = dist_path.join("assets")
      assets_path.join(name).make_symlink symlink_path unless symlink_path.exist?
    end

    def add_assets_to_precompile_list
      Rails.configuration.assets.precompile << /(?:\/|\A)#{name}\//
    end

    def command(options={})
      watch = options[:watch] ? "--watch" : ""
      "#{ember_path} build #{watch} --environment #{environment} --output-path #{dist_path} #{log_pipe}"
    end

    def log_pipe
      "| #{tee_path} -a #{log_path}" if tee_path
    end

    def ember_app_name
      @ember_app_name ||= options.fetch(:name){ package_json.fetch(:name) }
    end

    def app_path
      @app_path ||= begin
        path = options.fetch(:path){ Rails.root.join("app", name) }
        Pathname.new(path)
      end
    end

    def log_path
      Rails.root.join("log", "ember-#{name}.#{Rails.env}.log")
    end

    def dist_path
      @dist_path ||= EmberCLI.root.join("apps", name).tap(&:mkpath)
    end

    def assets_path
      @assets_path ||= EmberCLI.root.join("assets").tap(&:mkpath)
    end

    def environment
      Helpers.non_production?? "development" : "production"
    end

    def package_json
      @package_json ||= JSON.parse(app_path.join("package.json").read).with_indifferent_access
    end
  end
end
