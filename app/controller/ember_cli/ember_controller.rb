module EmberCli
  class EmberController < ::ApplicationController
    def index
      EmberCli.build(ember_app)

      render layout: false
    end

    def ember_app
      params[:ember_app]
    end
    helper_method :ember_app
  end
end
