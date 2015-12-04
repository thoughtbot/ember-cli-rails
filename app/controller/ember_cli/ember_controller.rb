module EmberCli
  class EmberController < ::ApplicationController
    def index
      @app = params[:ember_app]

      EmberCli.build(@app)

      render layout: false
    end
  end
end
