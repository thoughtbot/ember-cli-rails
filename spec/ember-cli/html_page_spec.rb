describe EmberCLI::HtmlPage do
  describe "#render" do
    it "resolves the Sprockets URLs in the content" do
      asset_resolver = double("EmberCLI::AssetResolver")
      html_page = EmberCLI::HtmlPage.new(
        asset_resolver: asset_resolver,
        content: :markup,
      )
      allow(asset_resolver).
        to receive(:resolve_urls).
        with(:markup).
        and_return(:delegated)

      rendered = html_page.render

      expect(rendered).to be :delegated
    end
  end
end
