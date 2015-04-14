module EmberCLI
  class Engine < Rails::Engine
    initializer "ember-cli-rails.inflector" do
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.acronym "CLI" if inflect.respond_to?(:acronym)
      end
    end

    initializer "ember-cli-rails.enable" do
      EmberCLI.enable! unless EmberCLI.skip?
    end

    initializer "ember-cli-rails.helpers" do
      config.to_prepare do
        ActionController::Base.helper EmberRailsHelper
      end
    end
  end
end
