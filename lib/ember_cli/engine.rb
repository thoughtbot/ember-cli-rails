module EmberCli
  class Engine < Rails::Engine
    initializer "ember-cli-rails.setup" do
      require "ember_cli/ember_controller"
      require "ember_cli/route_helpers"

      ActionController::Base.helper EmberRailsHelper
    end
  end
end
