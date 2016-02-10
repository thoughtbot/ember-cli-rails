module EmberCli
  class EmberController < ActionController::Base
    def index
      render layout: false
    end
  end
end
