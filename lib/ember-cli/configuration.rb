require "singleton"

module EmberCLI
  class Configuration
    include Singleton

    def app(name, options={})
      if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
        apps.store name, AppWin.new(name, options)
      else
        apps.store name, App.new(name, options)
      end
    end

    def apps
      @apps ||= HashWithIndifferentAccess.new
    end

    def tee_path
      return @tee_path if defined?(@tee_path)
      @tee_path = Helpers.which("tee")
    end

    def npm_path
      @npm_path ||= Helpers.which("npm")
    end

    def bundler_path
      @bundler_path ||= Helpers.which("bundler")
    end

    def build_timeout
      @build_timeout ||= 5
    end

    attr_writer :build_timeout
  end
end
