module EmberCli
  module ControllerExtension
    def self.included(base)
      build_ember_app = lambda do
        app = params[:ember_app]

        if app.present?
          EmberCli[app].build
        end
      end

      if base.respond_to?(:before_action)
        base.before_action(&build_ember_app)
      else
        base.before_filter(&build_ember_app)
      end
    end
  end
end
