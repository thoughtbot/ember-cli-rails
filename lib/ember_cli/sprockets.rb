require "ember_cli/errors"
require "non-stupid-digest-assets"
require "ember_cli/html_page"

module EmberCli
  class Sprockets
    class AssetPipelineError < BuildError; end
    def initialize(app)
      @app = app
    end

    def register!
      register_or_raise!(Rails.configuration.assets.precompile)
      register_or_raise!(NonStupidDigestAssets.whitelist)
    end

    def index_html(head:, body:)
      html_page = HtmlPage.new(
        content: app.index_file.read,
        head: head,
        body: body,
      )

      html_page.render
    end

    def assets
      ["#{app.name}/assets/vendor", "#{app.name}/assets/#{ember_app_name}"]
    end

    private

    attr_reader :app

    def ember_app_name
      @ember_app_name ||= app.options.fetch(:name) { package_json.fetch(:name) }
    end

    def package_json
      @package_json ||=
        JSON.parse(app.paths.package_json_file.read).with_indifferent_access
    end

    def asset_matcher
      %r{\A#{app.name}/}
    end

    def register_or_raise!(precompiled_assets)
      if precompiled_assets.include?(asset_matcher)
        raise AssetPipelineError.new <<-MSG.strip_heredoc
          EmberCLI application #{app.name.inspect} already registered!
        MSG
      else
        precompiled_assets << asset_matcher
      end
    end
  end
end
