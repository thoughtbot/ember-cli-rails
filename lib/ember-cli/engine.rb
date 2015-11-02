module EmberCli
  class Engine < Rails::Engine
    initializer "ember-cli-rails.enable" do
      EmberCli.enable! unless EmberCli.skip?
    end

    initializer "ember-cli-rails.helpers" do
      config.to_prepare do
        ActionController::Base.helper EmberRailsHelper
      end
    end
  end
end
