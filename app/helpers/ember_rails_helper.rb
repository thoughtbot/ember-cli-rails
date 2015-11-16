require "ember_cli/capture"

module EmberRailsHelper
  def include_ember_index_html(name, &block)
    warn <<-MSG.strip_heredoc
      The `include_ember_index_html` helper has been deprecated.

      Rename all invocations to `render_ember_app`
    MSG

    render_ember_app(name, &block)
  end

  def render_ember_app(name, &block)
    markup_capturer = EmberCli::Capture.new(sprockets: self, &block)

    head, body = markup_capturer.capture

    render inline: EmberCli[name].sprockets.index_html(head: head, body: body)
  end

  def include_ember_script_tags(name, **options)
    javascript_include_tag(*EmberCli[name].sprockets.assets, options)
  end

  def include_ember_stylesheet_tags(name, **options)
    stylesheet_link_tag(*EmberCli[name].sprockets.assets, options)
  end
end
