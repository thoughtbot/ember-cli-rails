module EmberCLI
  class Railtie < Rails::Railtie
    initializer "ember-cli-rails.rack-server" do
      EmberCLI.prepare! if development_mode?
    end

    initializer "ember-cli-rails.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    def development_mode?
      !Rails.env.production? && Rails.configuration.consider_all_requests_local
    end
  end
end
