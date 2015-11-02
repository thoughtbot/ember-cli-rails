require "ember-cli/asset_resolver"

describe EmberCli::AssetResolver do
  describe "#resolve_urls" do
    context "substitues asset pipeline paths" do
      it "for application javascript" do
        app = double(
          name: "frontend",
          application_assets: ["app", "asset"],
          vendor_assets: ["vendor", "asset"],
        )
        sprockets = SprocketsMock.new
        asset_resolver = EmberCli::AssetResolver.new(
          app: app,
          sprockets: sprockets,
        )
        content = html_content

        html = asset_resolver.resolve_urls(content).split("\n").map(&:strip)

        expect(content).to eq html_content
        expect(html).to eq [
          %{<a href="unchanged/assets/frontend.js"></a>},
          %{<a href="unchanged/assets/frontend.css"></a>},
          %{<script src="app/asset.js"></script>},
          %{<link href="app/asset.css"></script>},
          %{<a href="unchanged/assets/vendor.js"></a>},
          %{<a href="unchanged/assets/vendor.css"></a>},
          %{<script src="vendor/asset.js"></script>},
          %{<link href="vendor/asset.css"></script>},
        ]
      end
    end
  end

  def html_content
    <<-HTML
      <a href="unchanged/assets/frontend.js"></a>
      <a href="unchanged/assets/frontend.css"></a>
      <script src="assets/frontend.js"></script>
      <link href="assets/frontend.css"></script>
      <a href="unchanged/assets/vendor.js"></a>
      <a href="unchanged/assets/vendor.css"></a>
      <script src="assets/vendor.js"></script>
      <link href="assets/vendor.css"></script>
    HTML
  end

  class SprocketsMock
    def asset_path(routes, type: :javascript)
      [routes.join("/"), extension_for(type)].join(".")
    end
    alias :vendor_path :asset_path

    private

    def extension_for(type)
      if type == :javascript
        "js"
      else
        "css"
      end
    end
  end
end
