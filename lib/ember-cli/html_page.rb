module EmberCli
  class HtmlPage
    def initialize(content:, asset_resolver:, head: "", body: "")
      @content = content
      @asset_resolver = asset_resolver
      @head = head
      @body = body
    end

    def render
      if has_head_tag?
        insert_head_content
      end

      if has_body_tag?
        insert_body_content
      end

      html
    end

    private

    def has_head_tag?
      head_tag_index >= 0
    end

    def has_body_tag?
      body_tag_index >= 0
    end

    def insert_head_content
      html.insert(head_tag_index, @head.to_s)
    end

    def insert_body_content
      html.insert(body_tag_index, @body.to_s)
    end

    def html
      @html ||= resolved_html
    end

    def head_tag_index
      html.index("</head") || -1
    end

    def body_tag_index
      html.index("</body") || -1
    end

    def resolved_html
      @asset_resolver.resolve_urls(@content)
    end
  end
end
