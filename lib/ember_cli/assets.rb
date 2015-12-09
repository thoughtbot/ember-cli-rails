require "ember_cli/errors"
require "ember_cli/asset_map"
require "ember_cli/directory_asset_map"

module EmberCli
  class Assets
    def initialize(app)
      @app = app
    end

    def javascript_assets
      asset_map.javascripts
    end

    def stylesheet_assets
      asset_map.stylesheets
    end

    private

    attr_reader :app

    def asset_map
      AssetMap.new(
        ember_app_name: ember_app_name,
        asset_map: asset_map_hash.to_h,
      )
    end

    def asset_map_file
      app.paths.asset_map
    end

    def asset_map_hash
      if asset_map_file.present? && asset_map_file.exist?
        JSON.parse(asset_map_file.read)
      else
        DirectoryAssetMap.new(app.paths.assets)
      end
    end

    def ember_app_name
      @ember_app_name ||= app.options.fetch(:name) { package_json.fetch(:name) }
    end

    def package_json
      @package_json ||=
        JSON.parse(app.paths.package_json_file.read).with_indifferent_access
    end
  end
end
