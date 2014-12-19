module EmberCLI
  module ViewHelpers
    def include_ember_script_tags(app_name)
      app = EmberCLI.configuration.apps.fetch(app_name)
      ember_javascript_include_tag *app.exposed_js_assets
    end

    def include_ember_stylesheet_tags(app_name)
      app = EmberCLI.configuration.apps.fetch(app_name)
      ember_stylesheet_link_tag *app.exposed_css_assets
    end

    def ember_asset_path(path)
      if EmberCLI::Helpers.non_production?
        [ Rails.configuration.assets.prefix, path ] * ?/
      else
        path
      end
    end

    def ember_javascript_include_tag(*paths)
      options = paths.extract_options!
      javascript_include_tag(*paths.map(&method(:ember_asset_path)), options)
    end

    def ember_stylesheet_link_tag(*paths)
      options = paths.extract_options!
      stylesheet_link_tag(*paths.map(&method(:ember_asset_path)), options)
    end

  end
end
