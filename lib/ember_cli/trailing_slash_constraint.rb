module EmberCli
  class TrailingSlashConstraint
    def matches?(request)
      !request.original_fullpath.to_s.ends_with?("/")
    end
  end
end
