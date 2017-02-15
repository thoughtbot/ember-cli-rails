require "html_page/capture"

module EmberRailsHelper
  def render_ember_app(name, &block)
    EmberCli[name].build

    markup_capturer = HtmlPage::Capture.new(self, &block)

    head, body = markup_capturer.capture

    render text: EmberCli[name].index_html(head: head, body: body).html_safe
  end

  def include_ember_alternative_stylesheet_tags(app_name, *sources)
    app = EmberCLI[name]

    sources = sources.map do |source_or_option|
      (source_or_option.is_a? Hash) ? source_or_option : "#{app.name}/#{source_or_option}"
    end

    stylesheet_link_tag *sources
  end
end
