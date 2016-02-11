module EmberCli
  class EmberController < ::ApplicationController
    (::ActionController::Base::MODULES - ::ActionController::API::MODULES).each do |mod|
      include mod
    end

    def index
      render layout: false
    end
  end
end
