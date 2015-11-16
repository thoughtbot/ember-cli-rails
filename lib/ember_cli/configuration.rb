require "singleton"

module EmberCli
  class Configuration
    include Singleton

    def app(name, **options)
      if options.has_key? :build_timeout
        deprecate_timeout
      end

      if options.has_key? :enable
        deprecate_enable
      end

      app = App.new(name, options)
      app.sprockets.register!
      apps.store(name, app)
    end

    def apps
      @apps ||= HashWithIndifferentAccess.new
    end

    def tee_path
      return @tee_path if defined?(@tee_path)
      @tee_path = Helpers.which("tee")
    end

    def bower_path
      @bower_path ||= Helpers.which("bower")
    end

    def npm_path
      @npm_path ||= Helpers.which("npm")
    end

    def bundler_path
      @bundler_path ||= Helpers.which("bundler")
    end

    def build_timeout=(*)
      deprecate_timeout
    end

    attr_accessor :watcher

    private

    def deprecate_enable
      warn <<-WARN.strip_heredoc

      The `enable` lambda configuration has been removed.

      Please read https://github.com/thoughtbot/ember-cli-rails/pull/261 for
      details.

      WARN
    end

    def deprecate_timeout
      warn <<-WARN.strip_heredoc

      The `build_timeout` configuration has been removed.

      Please read https://github.com/thoughtbot/ember-cli-rails/pull/259 for
      details.

      WARN
    end
  end
end
