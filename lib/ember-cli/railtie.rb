module EmberCLI
  class Railtie < Rails::Railtie
    initializer "ember-cli-rails.rack-server" do
      EmberCLI.prepare! if development_mode?
    end

    def development_mode?
      !Rails.env.production? && Rails.configuration.consider_all_requests_local
    end
  end
end
