module EmberCLI
  class AssetResolver
    def initialize(app:, sprockets:)
      @app = app
      @sprockets = sprockets
    end

    def resolve_urls(html_content)
      mappings.reduce(html_content) do |resolved_content, (asset, new_path)|
        resolved_content.gsub(%{"assets/#{asset}"}, %{"#{new_path}"})
      end
    end

    private

    def mappings
      {
        "#{name}.js" => application.js,
        "#{name}.css" => application.css,
        "vendor.js" => vendor.js,
        "vendor.css" => vendor.css,
      }
    end

    def name
      @app.name
    end

    def application
      AssetPath.new(@sprockets, @app.application_assets)
    end

    def vendor
      AssetPath.new(@sprockets, @app.vendor_assets)
    end

    class AssetPath
      def initialize(sprockets, assets)
        @sprockets = sprockets
        @assets = assets
      end

      def js
        @sprockets.asset_path(@assets, type: :javascript)
      end

      def css
        @sprockets.asset_path(@assets, type: :stylesheet)
      end
    end

    private_constant :AssetPath
  end
end
