require "ember-cli/capture"

module EmberRailsHelper
  def include_ember_index_html(name, &block)
    markup_capturer = EmberCLI::Capture.new(sprockets: self, &block)

    head, body = markup_capturer.capture

    html = EmberCLI[name].index_html(
      sprockets: self,
      head: head,
      body: body,
    )

    render inline: html
  end

  def include_ember_script_tags(name, **options)
    javascript_include_tag(*EmberCLI[name].exposed_js_assets, options)
  end

  def include_ember_stylesheet_tags(name, **options)
    stylesheet_link_tag(*EmberCLI[name].exposed_css_assets, options)
  end
end
