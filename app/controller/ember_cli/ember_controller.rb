module EmberCli
  class EmberController < ::ApplicationController
    def index
      render layout: false
    end
  end
end
