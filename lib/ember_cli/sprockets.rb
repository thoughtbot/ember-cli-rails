require "non-stupid-digest-assets"
require "ember_cli/html_page"

module EmberCli
  class Sprockets
    def initialize(app)
      @app = app
    end

    def register!
      assets = %r{\A#{app.name}/}

      Rails.configuration.assets.precompile << assets
      NonStupidDigestAssets.whitelist << assets
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
  end
end
