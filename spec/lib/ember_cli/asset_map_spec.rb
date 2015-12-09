require "ember_cli/asset_map"

describe EmberCli::AssetMap do
  describe "#javascripts" do
    it "includes the most recent javascript build artifacts" do
      asset_map = {
        "assets" => {
          "not-a-match" => {},
          "bar.js" => "bar-abc123.js",
          "vendor.js" => "vendor-abc123.js",
        },
        "prepend" => "foo/",
      }
      assets = build_assets(
        ember_app_name: "bar",
        asset_map: asset_map,
      )

      javascripts = assets.javascripts

      expect(javascripts).to match_array([
        "foo/bar-abc123.js",
        "foo/vendor-abc123.js",
      ])
    end

    context "when the asset_map is empty" do
      it "raises a BuildError" do
        assets = build_assets(
          asset_map: {},
          ember_app_name: "bar",
        )

        expect { assets.javascripts }.to raise_error(EmberCli::BuildError)
      end
    end
  end

  describe "#stylesheets" do
    it "includes the most recent stylesheet build artifacts" do
      asset_map = {
        "assets" => {
          "not-a-match" => {},
          "bar.css" => "bar-abc123.css",
          "vendor.css" => "vendor-abc123.css",
        },
        "prepend" => "foo/",
      }
      assets = build_assets(
        ember_app_name: "bar",
        asset_map: asset_map,
      )

      stylesheets = assets.stylesheets

      expect(stylesheets).to match_array([
        "foo/bar-abc123.css",
        "foo/vendor-abc123.css",
      ])
    end

    context "when the asset_map is empty" do
      it "raises a BuildError" do
        assets = build_assets(
          asset_map: {},
          ember_app_name: "bar",
        )

        expect { assets.stylesheets }.to raise_error(EmberCli::BuildError)
      end
    end
  end
end

def build_assets(asset_map: {}, **options)
  EmberCli::AssetMap.new(options.merge(asset_map: asset_map))
end
