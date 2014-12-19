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

    def ember_path
      @ember_path ||= Helpers.which("ember").tap do |path|
        fail "ember-cli executable could not be found" unless path
      end
    end

    def build_timeout
      @build_timeout ||= 5
    end

    attr_writer :ember_path, :build_timeout
  end
end
