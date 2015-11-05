module EmberCli
  class PathSet
    def self.define_path(name, &definition)
      define_method name do
        ivar = "@_#{name}_path"
        if instance_variable_defined?(ivar)
          instance_variable_get(ivar)
        else
          instance_exec(&definition).tap{ |value| instance_variable_set ivar, value }
        end
      end
    end

    def initialize(app)
      @app = app
    end

    define_path :root do
      path = app_options.fetch(:path){ default_root }
      pathname = Pathname.new(path)
      pathname.absolute?? pathname : Rails.root.join(path)
    end

    define_path :tmp do
      root.join("tmp").tap(&:mkpath)
    end

    define_path :log do
      Rails.root.join("log", "ember-#{app_name}.#{Rails.env}.log")
    end

    define_path :dist do
      EmberCli.root.join("apps", app_name).tap(&:mkpath)
    end

    define_path :assets do
      EmberCli.root.join("assets").tap(&:mkpath)
    end

    define_path :applications do
      Rails.root.join("public", "_apps").tap(&:mkpath)
    end

    define_path :gemfile do
      root.join("Gemfile")
    end

    define_path :tests do
      dist.join("tests")
    end

    define_path :package_json_file do
      root.join("package.json")
    end

    define_path :node_modules do
      root.join("node_modules")
    end

    define_path :ember do
      root.join("node_modules", ".bin", "ember").tap do |path|
        fail <<-MSG.strip_heredoc unless path.executable?
          No local ember executable found. You should run `npm install`
          inside the #{app_name} app located at #{root}
        MSG
      end
    end

    define_path :lockfile do
      tmp.join("build.lock")
    end

    define_path :build_error_file do
      tmp.join("error.txt")
    end

    define_path :ember_stderr_file do
      tmp.join("stderr.txt")
    end

    define_path :tee do
      app_options.fetch(:tee_path){ configuration.tee_path }
    end

    define_path :bower do
      app_options.fetch(:bower_path) { configuration.bower_path }
    end

    define_path :npm do
      app_options.fetch(:npm_path){ configuration.npm_path }
    end

    define_path :bundler do
      app_options.fetch(:bundler_path){ configuration.bundler_path }
    end

    define_path :addon_package_json_file do
      root.join("node_modules", "ember-cli-rails-addon", "package.json")
    end

    private

    attr_reader :app

    delegate :name, :options, to: :app, prefix: true
    delegate :configuration, to: EmberCli

    def default_root
      Rails.root.join(app_name)
    end
  end
end
