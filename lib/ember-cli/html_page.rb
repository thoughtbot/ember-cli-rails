module EmberCLI
  class HtmlPage
    def initialize(options)
      @content = options.fetch(:content)
      @asset_resolver = options.fetch(:asset_resolver)
    end

    def render
      @asset_resolver.resolve_urls(@content)
    end
  end
end
