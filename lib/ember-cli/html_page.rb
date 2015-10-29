module EmberCLI
  class HtmlPage
    def initialize(content:, asset_resolver:)
      @content = content
      @asset_resolver = asset_resolver
    end

    def render
      @asset_resolver.resolve_urls(@content)
    end
  end
end
