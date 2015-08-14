module EmberCli
  class BuildConstraint
    TRUE_PROC = ->(*) { true }

    def initialize(request:, block:)
      @request = request
      @block = block || TRUE_PROC
    end

    def enabled?
      block.call(*arguments)
    end

    private

    attr_reader :request, :block

    def arguments
      [path, request].first([block.arity, 0].max)
    end

    def path
      request.path_info
    end
  end
end
