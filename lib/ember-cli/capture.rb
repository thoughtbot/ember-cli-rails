module EmberCLI
  SKIP_CAPTURE = ["", ""].freeze

  class Capture
    def initialize(sprockets:, &block)
      @sprockets = sprockets
      @block = block
    end

    def capture
      if block.present?
        capture_block
      else
        SKIP_CAPTURE
      end
    end

    private

    attr_reader :block, :sprockets

    def capture_block
      if block.arity > 0
        block.call(*block_arguments)
      end

      [captured_head.content, captured_body.content]
    end

    def block_arguments
      [captured_head, captured_body].first(block.arity)
    end

    def captured_body
      @captured_body ||= Block.new(sprockets)
    end

    def captured_head
      @captured_head ||= begin
        if block.arity < 1
          BlockWithoutArguments.new(sprockets, &block)
        else
          Block.new(sprockets)
        end
      end
    end

    class BlockWithoutArguments
      def initialize(sprockets, &block)
        @sprockets = sprockets
        @block = block
      end

      def content
        @sprockets.capture(&@block)
      end
    end
    private_constant :BlockWithoutArguments

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
