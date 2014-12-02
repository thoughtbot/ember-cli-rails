module EmberCLI
  class Railtie < Rails::Railtie
    initializer "ember-cli-rails.rack-server" do
      EmberCLI.prepare! if development_mode?
    end

    initializer "ember-cli-rails.view_helpers" do
      ActionView::Base.include ViewHelpers
    end

    initializer "ember-cli-rails.inflector" do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym "CLI"
      end
    end

    def development_mode?
      !Rails.env.production? && Rails.configuration.consider_all_requests_local
    end
  end
end
