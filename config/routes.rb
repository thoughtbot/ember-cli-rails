EmberCLI::Engine.routes.draw do
  get ":app" => "ember_tests#index", format: false, as: false
end
