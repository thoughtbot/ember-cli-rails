require "ember_cli/assets"

describe EmberCli::Assets do
  describe "#javascripts" do
    it "includes the most recent javascript build artifacts" do
      manifest = build_manifest(
        assets: {
          "foo/assets/bar.js" => "foo/assets/bar-abc123.js",
          "foo/assets/vendor.js" => "foo/assets/vendor-abc123.js",
        },
        files: {
          "not-a-match" => {},
          "foo/assets/bar-abc123.js" => { "mtime" => 1.day.ago.iso8601 },
          "foo/assets/bar-def456.js" => { "mtime" => 2.days.ago.iso8601 },
          "foo/assets/vendor-def456.js" => { "mtime" => 2.days.ago.iso8601 },
          "foo/assets/vendor-abc123.js" => { "mtime" => 1.day.ago.iso8601 },
        },
      )
      assets = build_assets(
        app_name: "foo",
        ember_app_name: "bar",
        manifest: manifest,
      )

      javascripts = assets.javascripts

      expect(javascripts).to match_array([
        "foo/assets/bar.js",
        "foo/assets/vendor.js",
      ])
    end

    context "when the manifest is empty" do
      it "falls back to the default assets" do
        assets = build_assets(
          manifest: build_empty_manifest,
          app_name: "foo",
          ember_app_name: "bar",
        )

        javascripts = assets.javascripts

        expect(javascripts).to match_array([
          "foo/assets/vendor",
          "foo/assets/bar",
        ])
      end
    end
  end

  describe "#stylesheets" do
    it "includes the most recent stylesheet build artifacts" do
      manifest = build_manifest(
        assets: {
          "foo/assets/bar.css" => "foo/assets/bar-abc123.css",
          "foo/assets/vendor.css" => "foo/assets/vendor-abc123.css",
        },
        files: {
          "not-a-match" => {},
          "foo/assets/bar-def456.css" => { "mtime" => 2.days.ago.iso8601 },
          "foo/assets/bar-abc123.css" => { "mtime" => 1.day.ago.iso8601 },
          "foo/assets/vendor-abc123.css" => { "mtime" => 1.day.ago.iso8601 },
          "foo/assets/vendor-def456.css" => { "mtime" => 2.days.ago.iso8601 },
        },
      )
      assets = build_assets(
        app_name: "foo",
        ember_app_name: "bar",
        manifest: manifest,
      )

      stylesheets = assets.stylesheets

      expect(stylesheets).to match_array([
        "foo/assets/bar.css",
        "foo/assets/vendor.css",
      ])
    end

    context "when the manifest is empty" do
      it "falls back to the default assets" do
        assets = build_assets(
          manifest: build_empty_manifest,
          app_name: "foo",
          ember_app_name: "bar",
        )

        stylesheets = assets.stylesheets

        expect(stylesheets).to match_array([
          "foo/assets/vendor",
          "foo/assets/bar",
        ])
      end
    end
  end
end

def build_assets(manifest: build_manifest, **options)
  EmberCli::Assets.new(options.merge(manifest: manifest))
end

def build_manifest(assets: {}, files: {})
  double(files: files, assets: assets)
end

def build_empty_manifest
  build_manifest
end
