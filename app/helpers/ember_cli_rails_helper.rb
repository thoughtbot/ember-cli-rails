module EmberCLIRailsHelper
  def include_ember_script_tags(name)
    javascript_include_tag *EmberCLI[name].exposed_js_assets
  end

  def include_ember_stylesheet_tags(name)
    stylesheet_link_tag *EmberCLI[name].exposed_css_assets
  end
end
