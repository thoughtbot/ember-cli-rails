module EmberCli
  class EmberController < ::ApplicationController
    unless ancestors.include? ActionController::Base
      (
        ::ActionController::Base::MODULES -
        ::ActionController::API::MODULES
      ).each do |mod|
        include mod
      end

      helper EmberRailsHelper
    end
    #
    def index
      render layout: false
    end
  end
end
