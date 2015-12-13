require "ember_cli/errors"

module EmberCli
  module Deploy
    class File
      def initialize(app)
        @app = app
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
