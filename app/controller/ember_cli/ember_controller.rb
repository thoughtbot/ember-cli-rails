module EmberCli
  class EmberController < ::ApplicationController
    def index
      render layout: false
    end

    def ember_app
      params[:ember_app]
    end
    helper_method :ember_app
  end
end
