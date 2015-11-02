describe EmberCli::HtmlPage do
  describe "#render" do
    context "when <head> is present" do
      it "injects into the <head>" do
        content = valid_content
        html_page = EmberCli::HtmlPage.new(
          asset_resolver: build_asset_resolver(content),
          content: content,
          head: "injected!",
        )

        rendered = html_page.render

        expect(rendered).to eq(
          "<html><head><title></title>injected!</head><body><h1></h1></body></html>",
        )
      end
    end

    context "when <body> is present" do
      it "injects into the <body>" do
        content = valid_content
        html_page = EmberCli::HtmlPage.new(
          asset_resolver: build_asset_resolver(content),
          content: content,
          body: "injected!",
        )

        rendered = html_page.render

        expect(rendered).to eq(
          "<html><head><title></title></head><body><h1></h1>injected!</body></html>",
        )
      end
    end

    context "when the page isn't valid" do
      it "does nothing" do
        content = "<html></html>"
        html_page = EmberCli::HtmlPage.new(
          asset_resolver: build_asset_resolver(content),
          content: content,
          head: "injected!",
          body: "injected!",
        )

        rendered = html_page.render

        expect(rendered).to eq("<html></html>")
      end
    end

    def build_asset_resolver(content)
      resolver = double("EmberCli::AssetResolver")
      allow(resolver).
        to receive(:resolve_urls).
        with(content).
        and_return(content)

      resolver
    end

    def valid_content
      "<html><head><title></title></head><body><h1></h1></body></html>"
    end
  end
end
