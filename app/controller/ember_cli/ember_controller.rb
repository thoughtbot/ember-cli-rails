module EmberCli
  class EmberController < ::ApplicationController
    unless ancestors.include? ActionController::Base
      (
        ActionController::Base::MODULES -
        ActionController::API::MODULES
      ).each do |controller_module|
        include controller_module
      end

      helper EmberRailsHelper
    end

    def index
      render layout: false
    end
  end
end
