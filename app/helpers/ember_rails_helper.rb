require "html_page/capture"

module EmberRailsHelper
  def render_ember_app(name, &block)
    EmberCli[name].build

    markup_capturer = HtmlPage::Capture.new(self, &block)

    head, body = markup_capturer.capture

    template = EmberCli[name].index_html(head: head, body: body).html_safe
    begin
      render text: template
    rescue ArgumentError
      render body: template
    end
  end
end
