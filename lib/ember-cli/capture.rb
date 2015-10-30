module EmberCLI
  class Capture
    def initialize(sprockets:, &block)
      @sprockets = sprockets
      @block = block
    end

    def capture
      if block.present?
        if block.arity == 0
          capture_block
        else
          captured_head_and_body
        end
      else
        ["", ""]
      end
    end

    private

    attr_reader :block, :sprockets

    def captured_head_and_body
      arguments = [captured_head, captured_body].first(block.arity)

      block.call(*arguments)

      [captured_head.content, captured_body.content]
    end

    def capture_block
      [sprockets.capture(&block), ""]
    end

    def captured_body
      @captured_body ||= Block.new(sprockets)
    end

    def captured_head
      @captured_head ||= Block.new(sprockets)
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
