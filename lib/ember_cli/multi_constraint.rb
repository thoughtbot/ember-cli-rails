module EmberCli
  class MultiConstraint
    def initialize(*constraints)
      @constraints = constraints
    end

    def matches?(request)
      @constraints.all? { |c| c.matches?(request) }
    end
  end
end
