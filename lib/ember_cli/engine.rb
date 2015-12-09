module EmberCli
  class Engine < Rails::Engine
    initializer "ember-cli-rails.rendering" do
      require "ember_cli/ember_controller"
      require "ember_cli/route_helpers"
    end

    config.to_prepare do
      ActionController::Base.helper EmberRailsHelper
    end
  end
end
