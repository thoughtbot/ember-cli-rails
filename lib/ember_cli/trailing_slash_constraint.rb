module EmberCli
  class TrailingSlashConstraint
    def matches?(request)
      !request.original_fullpath.to_s.split('?')[0].ends_with?("/")
    end
  end
end
