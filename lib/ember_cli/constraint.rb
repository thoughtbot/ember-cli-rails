module EmberCli
  class Constraint
    def matches?(request)
      matches = request.format.to_s =~ /html/ || -1

      matches > -1
    end
  end
end
