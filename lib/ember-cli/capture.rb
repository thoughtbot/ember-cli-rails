module EmberCli
  SKIP_CAPTURE = ["", ""].freeze

  class Capture
    def initialize(sprockets:, &block)
      @sprockets = sprockets
      @block = block
    end

    def capture
      if block.present?
        capture_content
      else
        SKIP_CAPTURE
      end
    end

    private

    attr_reader :block, :sprockets

    def capture_content
      if block.arity > 0
        block.call(*block_arguments)
      end

      [head.content, body.content]
    end

    def block_arguments
      [head, body].first(block.arity)
    end

    def body
      @body ||= Block.new(sprockets)
    end

    def head
      @head ||= begin
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
        @sprockets.with_output_buffer(&@block)
      end
    end
    private_constant :BlockWithoutArguments

    class Block
      def initialize(sprockets)
        @sprockets = sprockets
        @content = []
      end

      def append(&block)
        @content.push(@sprockets.with_output_buffer(&block))
        nil
      end

      def content
        @content.join
      end
    end
    private_constant :Block
  end
end
