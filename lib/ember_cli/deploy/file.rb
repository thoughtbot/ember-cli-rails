require "rack"
require "ember_cli/errors"

module EmberCli
  module Deploy
    class File
      def initialize(app)
        @app = app
      end

      def mountable?
        true
      end

      def to_rack
        Rack::File.new(app.dist_path.to_s, rack_headers)
      end

      def index_html
        if index_file.exist?
          index_file.read
        else
          check_for_error_and_raise!
        end
      end

      private

      attr_reader :app

      def rack_headers
        config = Rails.configuration

        if config.respond_to?(:public_file_server) &&
            config.public_file_server && config.public_file_server.headers
          # Rails 5.
          config.public_file_server.headers
        elsif config.respond_to?(:static_cache_control)
          # Rails 4.2 and below.
          {
            "Cache-Control" => Rails.configuration.static_cache_control,
          }
        else
          # No specification.
          {}
        end
      end

      def check_for_error_and_raise!
        app.check_for_errors!

        raise BuildError.new <<-MSG
          EmberCLI failed to generate an `index.html` file.
        MSG
      end

      def index_file
        app.dist_path.join("index.html")
      end
    end
  end
end
