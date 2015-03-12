module EmberCLI
  class Engine < Rails::Engine
    initializer "ember-cli-rails.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    initializer "ember-cli-rails.inflector" do
      if Rails.version > "3.2"
        ActiveSupport::Inflector.inflections :en do |inflect|
          inflect.acronym "CLI"
        end
      end
    end

    initializer "ember-cli-rails.enable" do
      EmberCLI.enable! unless ENV["SKIP_EMBER"]
    end
  end
end
