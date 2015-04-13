require "singleton"

module EmberCLI
  class Configuration
    include Singleton

    def app(name, options={})
      apps.store name, App.new(name, options)
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

    def disable_fingerprints
      return @disable_fingerprints if defined? @disable_fingerprints
      @disable_fingerprints = true
    end

    attr_writer :build_timeout, :disable_fingerprints
  end
end
