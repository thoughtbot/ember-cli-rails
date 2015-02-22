EmberCLI::Engine.routes.draw do
  get ":app_name", to: "ember_tests#index", format: false
end
