module EmberCli
  class EmberController < ::ActionController::Base
    def index
      @app = params[:ember_app]

      render layout: false
    end
  end
end
