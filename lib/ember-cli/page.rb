module EmberCLI
  class Page
    def initialize(html:)
      @html = html.clone
      @body_markup = []
      @head_markup = []
    end

    def build
      if has_head?
        head_markup.each do |markup|
          html.insert(head_position, markup)
        end
      end

      if has_body?
        body_markup.each do |markup|
          html.insert(body_position, markup)
        end
      end

      html
    end

    def append_to_body(markup)
      body_markup << markup
    end

    def append_to_head(markup)
      head_markup << markup
    end

    private

    attr_reader :body_markup, :head_markup, :html

    def has_head?
      html.include?("<head")
    end

    def has_body?
      html.include?("<body")
    end

    def head_position
      html.index(">", html.index("<head")) + 1
    end

    def body_position
      html.index(">", html.index("<body")) + 1
    end
  end
end
