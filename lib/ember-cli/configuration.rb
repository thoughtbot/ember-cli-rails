require "singleton"

module EmberCLI
  class Configuration
    include Singleton

    def app(name, **options)
      app_list << BuildServer.new(name, options)
    end

    def app_list
      @app_list ||= []
    end
  end
end
