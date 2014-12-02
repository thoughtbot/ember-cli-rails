module EmberCLI
  module ViewHelpers
    def include_ember_script_tags(app_name)
      app = EmberCLI.configuration.apps.fetch(app_name)
      javascript_include_tag *app.exposed_js_assets
    end
  end
end
