require "html_page/capture"

module EmberRailsHelper
  def render_ember_app(name, &block)
    EmberCli[name].build

    markup_capturer = HtmlPage::Capture.new(self, &block)

    head, body = markup_capturer.capture

    render html: EmberCli[name].index_html(head: head, body: body).html_safe
  end
end
