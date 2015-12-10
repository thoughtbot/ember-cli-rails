module Jekyll
  class RenderMarkdownTag < Liquid::Tag
    require "kramdown"

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      site = context.registers[:site]

      Kramdown::Document.new(parsed_markdown(site)).to_html
    end

    private

    def parsed_markdown(site)
      (Liquid::Template.parse markdown_file).render(site.site_payload)
    end

    def markdown_file
      File.read(File.join(Dir.pwd, "_includes", @text))
    end
  end
end

Liquid::Template.register_tag('render_markdown', Jekyll::RenderMarkdownTag)
