module EmberCli
  module ControllerExtension
    def self.included(base)
      base.before_action do
        if params.has_key?(:ember_app)
          EmberCli.process_path(request.path_info)
        end
      end
    end
  end
end
