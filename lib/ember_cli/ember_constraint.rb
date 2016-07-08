module EmberCli
  class EmberConstraint
    def matches?(request)
      html_request?(request) && !rails_info_request?(request)
    end

    private

    def rails_info_request?(request)
      request.fullpath.start_with?("/rails/info")
    end

    def html_request?(request)
      index = request.format.to_s =~ /html/ || -1

      index > -1
    end
  end
end
