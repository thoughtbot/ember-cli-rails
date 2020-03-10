module EmberCli
  class EmberConstraint
    def matches?(request)
      html_request?(request) &&
        !rails_info_request?(request) &&
        !rails_active_storage_request?(request)
    end

    private

    def rails_info_request?(request)
      request.fullpath.start_with?("/rails/info", "/rails/mailers")
    end

    def rails_active_storage_request?(request)
      request.fullpath.start_with?("/rails/active_storage")
    end

    def html_request?(request)
      request.format.html?
    end
  end
end
