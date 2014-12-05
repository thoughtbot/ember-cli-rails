module EmberCLI
  module RackServer
    def start
      EmberCLI.run! if defined?(Rails.application) && app == Rails.application
      super
    ensure
      EmberCLI.stop!
    end
  end
end
