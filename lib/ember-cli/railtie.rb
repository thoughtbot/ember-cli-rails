module EmberCLI
  class Railtie < Rails::Railtie
    initializer "ember-cli-rails.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    initializer "ember-cli-rails.inflector" do
      ActiveSupport::Inflector.inflections :en do |inflect|
        inflect.acronym "CLI"
      end
    end

    initializer "ember-cli-rails.enable" do
      EmberCLI.enable! if EmberCLI::Helpers.non_production?
    end

    rake_tasks do
      require "sprockets/rails/task"
      EmberCLI::Helpers.override_assets_precompile_task!
    end

  end
end
