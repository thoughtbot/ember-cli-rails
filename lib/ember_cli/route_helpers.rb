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

        dist_directory = ::EmberCli[app_name].paths.dist

        mount Rack::File.new(dist_directory.to_s) => to
      end
    end
  end
end
