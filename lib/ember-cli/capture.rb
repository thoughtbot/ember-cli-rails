module EmberCLI
  class Capture
    attr_reader :body, :head

    def initialize(sprockets:, &block)
      @sprockets = sprockets
      @block = block
    end

    def capture
      if @block.present?
        if @block.arity == 0
          @head = @sprockets.capture(&@block)
          @body = ""
        else
          arguments = [captured_head, captured_body].first(@block.arity)
          @block.call(*arguments)
          @head = captured_head.content
          @body = captured_body.content
        end

        [@head, @body]
      else
        ["", ""]
      end
    end

    private

    def captured_body
      @captured_body ||= Block.new(@sprockets)
    end

    def captured_head
      @captured_head ||= Block.new(@sprockets)
    end

    class Block
      def initialize(sprockets)
        @sprockets = sprockets
        @content = []
      end

      def append(&block)
        @content.push(@sprockets.capture(&block))
      end

      def content
        @content.join
      end
    end
    private_constant :Block
  end
end
