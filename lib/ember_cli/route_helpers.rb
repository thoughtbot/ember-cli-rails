require "ember_cli/html_constraint"

module ActionDispatch
  module Routing
    class Mapper
      def mount_ember_assets(app_name, to: "/")
        dist_directory = EmberCli[app_name].paths.dist

        mount Rack::File.new(dist_directory.to_s) => to
      end

      def mount_ember_app(app_name, to:, **options)
        routing_options = options.deep_merge(
          defaults: { ember_app: app_name },
        )

        routing_options.reverse_merge!(
          controller: "ember_cli/ember",
          action: "index",
          format: :html,
        )

        Rails.application.routes.draw do
          scope constraints: EmberCli::HtmlConstraint.new do
            get("#{to}(*rest)", routing_options)
          end

          mount_ember_assets app_name, to: to
        end
      end
    end
  end
end
