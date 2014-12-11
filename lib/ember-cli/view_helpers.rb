module EmberCLI
  module ViewHelpers
    def include_ember_script_tags(app_name)
      app = EmberCLI.configuration.apps.fetch(app_name)
      javascript_include_tag *app.exposed_js_assets
    end

    def include_ember_stylesheet_tags(app_name)
      app = EmberCLI.configuration.apps.fetch(app_name)
      stylesheet_link_tag *app.exposed_css_assets
    end
  end
end
