module EmberCLI
  module ViewHelpers

    def include_ember_script_tags(app_name)
      javascript_include_tag "#{app_name}/vendor.js", "#{app_name}/#{app_name}.js" if app_name
    end

  end
end
