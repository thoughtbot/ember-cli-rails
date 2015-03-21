module EmberCLI
  class Engine < Rails::Engine
    initializer "ember-cli-rails.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    initializer "ember-cli-rails.inflector" do
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.acronym "CLI" if inflect.respond_to?(:acronym)
      end
    end

    initializer "ember-cli-rails.enable" do
      EmberCLI.enable! unless EmberCLI.skip?
    end
  end
end
