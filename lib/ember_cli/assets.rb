module EmberCli
  class Assets
    def initialize(app_name:, ember_app_name:, manifest:)
      @app_name = app_name
      @ember_app_name = ember_app_name
      @manifest = manifest
    end

    def javascripts
      if empty_manifest?
        fallback_assets
      else
        [
          latest_matching(%r{#{app_name}/assets/vendor(.*)\.js\z}),
          latest_matching(%r{#{app_name}/assets/#{ember_app_name}(.*)\.js\z}),
        ]
      end
    end

    def stylesheets
      if empty_manifest?
        fallback_assets
      else
        [
          latest_matching(%r{#{app_name}/assets/vendor(.*)\.css\z}),
          latest_matching(%r{#{app_name}/assets/#{ember_app_name}(.*)\.css\z}),
        ]
      end
    end

    private

    attr_reader :app_name, :ember_app_name, :manifest

    def fallback_assets
      ["#{app_name}/assets/vendor", "#{app_name}/assets/#{ember_app_name}"]
    end

    def empty_manifest?
      files.empty?
    end

    def latest_matching(regex)
      asset, = assets.detect { |(_, digest)| digest == latest_file_for(regex) }

      asset
    end

    def latest_file_for(regex)
      file, = files.
        select { |key, _| key =~ regex }.
        sort_by { |_, data| data["mtime"] }.
        last

      file
    end

    def assets
      manifest.assets
    end

    def files
      manifest.files
    end
  end
end
