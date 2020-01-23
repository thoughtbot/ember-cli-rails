module EmberCli
  class Engine < Rails::Engine
    initializer "ember-cli-rails.setup" do
      require "ember_cli/route_helpers"
    end
  end
end
