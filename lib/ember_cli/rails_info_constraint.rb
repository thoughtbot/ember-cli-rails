module EmberCli
  class RailsInfoConstraint
    def matches?(request)
      !request.fullpath.start_with?("/rails/info")
    end
  end
end
