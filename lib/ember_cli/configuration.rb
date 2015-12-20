require "singleton"
require "ember_cli/app"

module EmberCli
  class Configuration
    include Singleton

    attr_accessor :watcher

    def app(name, **options)
      app = App.new(name, options)
      apps.store(name, app)
    end

    def apps
      @apps ||= HashWithIndifferentAccess.new
    end
  end
end
