module EmberCLI
  module RackServer
    def start
      EmberCLI.start! if defined?(Rails.application) && app == Rails.application
      super
    ensure
      EmberCLI.stop!
    end
  end
end
