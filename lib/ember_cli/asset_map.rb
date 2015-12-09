require "ember_cli/errors"

module EmberCli
  class AssetMap
    def initialize(ember_app_name:, asset_map:)
      @ember_app_name = ember_app_name
      @asset_map = asset_map
    end

    def javascripts
      assert_asset_map!

      [
        asset_matching(%r{vendor(.*)\.js\z}),
        asset_matching(%r{#{ember_app_name}(.*)\.js\z}),
      ]
    end

    def stylesheets
      assert_asset_map!

      [
        asset_matching(%r{vendor(.*)\.css\z}),
        asset_matching(%r{#{ember_app_name}(.*)\.css\z}),
      ]
    end

    private

    attr_reader :app_name, :ember_app_name, :asset_map

    def asset_matching(regex)
      matching_asset = files.detect { |asset| asset =~ regex }

      if matching_asset.blank?
        raise_missing_asset(regex)
      end

      prepend + matching_asset
    end

    def prepend
      asset_map["prepend"].to_s
    end

    def files
      Array(assets.values)
    end

    def assets
      asset_map["assets"] || {}
    end

    def raise_missing_asset(regex)
      raise BuildError.new("Failed to find assets matching `#{regex}`")
    end

    def assert_asset_map!
      if assets.empty?
        raise BuildError.new("Missing `#{ember_app_name}/assets/assetMap.json`")
      end
    end
  end
end
