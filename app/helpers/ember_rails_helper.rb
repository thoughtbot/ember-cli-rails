module EmberRailsHelper
  def include_ember_index_html(name)
    render inline: EmberCLI[name].index_html(self)
  end

  def include_ember_script_tags(name, **options)
    javascript_include_tag *EmberCLI[name].exposed_js_assets, options
  end

  def include_ember_stylesheet_tags(name, **options)
    stylesheet_link_tag *EmberCLI[name].exposed_css_assets, options
  end
end
