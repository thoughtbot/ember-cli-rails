require "ember_cli/html_constraint"

module ActionDispatch
  module Routing
    class Mapper
      def mount_ember_app(app_name, to:, **options)
        routing_options = options.deep_merge(
          defaults: { ember_app: app_name },
        )

        routing_options.reverse_merge!(
          controller: "ember_cli/ember",
          action: "index",
          format: :html,
        )

        scope constraints: ::EmberCli::HtmlConstraint.new do
          get("#{to}(*rest)", routing_options)
        end

        mount_ember_assets(app_name, to: to)
      end

      def mount_ember_assets(app_name, to: "/")
        app = ::EmberCli[app_name]

        if app.mountable?
          mount app.to_rack => to
        end
      end
    end
  end
end
