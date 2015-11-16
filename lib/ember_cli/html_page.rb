module EmberCli
  class HtmlPage
    def initialize(content:, head: "", body: "")
      @content = content
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

      content
    end

    private

    attr_reader :content

    def has_head_tag?
      head_tag_index >= 0
    end

    def has_body_tag?
      body_tag_index >= 0
    end

    def insert_head_content
      content.insert(head_tag_index, @head.to_s)
    end

    def insert_body_content
      content.insert(body_tag_index, @body.to_s)
    end

    def head_tag_index
      content.index("</head") || -1
    end

    def body_tag_index
      content.index("</body") || -1
    end
  end
end
