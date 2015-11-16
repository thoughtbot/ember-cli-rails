module EmberCli
  module ControllerExtension
    def self.included(base)
      base.before_action do
        app = params[:ember_app]

        if app.present?
          EmberCli[app].build
        end
      end
    end
  end
end
