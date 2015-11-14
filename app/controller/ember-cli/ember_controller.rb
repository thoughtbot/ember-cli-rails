module EmberCli
  class EmberController < ::ApplicationController
    def index
      @app = params[:ember_app]

      render layout: false
    end
  end
end
