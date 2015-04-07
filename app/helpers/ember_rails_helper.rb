module EmberRailsHelper
  def include_ember_script_tags(name, options={})
    javascript_include_tag *EmberCLI[name].exposed_js_assets, options
  end

  def include_ember_stylesheet_tags(name, options={})
    stylesheet_link_tag *EmberCLI[name].exposed_css_assets, options
  end

  def include_ember_alternative_stylesheet_tags(app_name, *sources)
    app = EmberCLI[name]

    sources = sources.map do |source_or_option|
      (source_or_option.is_a? Hash) ? source_or_option : "#{app.name}/#{source_or_option}"
    end

    stylesheet_link_tag *sources
  end
end
