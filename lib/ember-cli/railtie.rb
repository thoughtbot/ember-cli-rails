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
      EmberCLI.enable! unless ENV["SKIP_EMBER"]
    end

    rake_tasks do
      load "tasks/ember-cli.rake"
    end
  end
end
