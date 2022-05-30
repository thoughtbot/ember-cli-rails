module EmberCli
  class TrailingSlashConstraint
    def matches?(request)
      !request.original_fullpath.to_s.split('?').first.end_with?("/")
    end
  end
end
