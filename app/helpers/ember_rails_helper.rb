require "ember_cli/capture"
require "ember_cli/assets"

module EmberRailsHelper
  def render_ember_app(name, &block)
    markup_capturer = EmberCli::Capture.new(sprockets: self, &block)

    head, body = markup_capturer.capture

    render inline: EmberCli[name].index_html(head: head, body: body)
  end

  def include_ember_script_tags(name, **options)
    assets = EmberCli::Assets.new(EmberCli[name])

    assets.javascript_assets.
      map { |src| %{<script src="#{src}"></script>}.html_safe }.
      reduce(&:+)
  end

  def include_ember_stylesheet_tags(name, **options)
    assets = EmberCli::Assets.new(EmberCli[name])

    assets.stylesheet_assets.
      map { |src| %{<link rel="stylesheet" href="#{src}">}.html_safe }.
      reduce(&:+)
  end
end
