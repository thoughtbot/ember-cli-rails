require "ember-cli/capture"

module EmberRailsHelper
  def include_ember_index_html(name, &block)
    markup_capturer = EmberCli::Capture.new(sprockets: self, &block)

    head, body = markup_capturer.capture

    html = EmberCli[name].index_html(
      sprockets: self,
      head: head,
      body: body,
    )

    render inline: html
  end

  def include_ember_script_tags(name, **options)
    javascript_include_tag(*EmberCli[name].exposed_js_assets, options)
  end

  def include_ember_stylesheet_tags(name, **options)
    stylesheet_link_tag(*EmberCli[name].exposed_css_assets, options)
  end
end
