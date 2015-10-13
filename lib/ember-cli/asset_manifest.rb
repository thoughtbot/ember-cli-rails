require "json"

module EmberCLI
  class AssetManifest
    ASSETS_KEY = "assets"
    FILES_KEY = "files"
    attr_reader :name, :rails_app, :data

    def self.assets_version
      case
      when Rails.application.respond_to?(:assets_manifest)
        4
      when Rails.application.config.assets.respond_to?(:digests)
        3
      else
        fail "Unknown asset pipeline version. Are you using Sprockets?"
      end
    end

    def initialize(name, rails_app = Rails.application)
      @name = name
      @data = {}
      @rails_app = rails_app
    end

    def rails_root
      rails_app.root
    end

    def asset_root
      asset_prefix = rails_app.config.assets.prefix || "/assets"
      @asset_root ||= "#{rails_root}/public#{asset_prefix}"
    end

    def asset_dist_path
      @asset_dist_path ||= "#{asset_root}/#{name}"
    end

    def manifest_file_path
      @manifest_file_path ||= Dir["#{asset_dist_path}/manifest.json"].first || Dir["#{asset_dist_path}/manifest*.json"].first
    end

    def load_manifest_data
      @data = if manifest_file_path
        JSON.parse( File.read( manifest_file_path ) )
      else
        _empty_manifest_data
      end
    end

    def exported_assets
      @data[ASSETS_KEY].inject({}) do |assets, pair|
        asset_path,digest_path = pair
        assets["#{name}/#{asset_path}"] = "#{name}/#{digest_path}"
        assets
      end
    end

    def exported_files
      @data[FILES_KEY].inject({}) do |files, pair|
        file_path,info = pair
        info = info.merge( "logical_path" => "#{name}/#{info['logical_path']}" )
        files["#{name}/#{file_path}"] = info
        files
      end
    end

    def inject_manifest
      load_manifest_data
      self.class.assets_version <= 3 ? _inject_v3 : _inject_v4
    end

    private
    def _empty_manifest_data
      { ASSETS_KEY => {}, FILES_KEY => {} }
    end
    def _inject_v3
      rails_app.config.assets.digests ||= {}
      rails_app.config.assets.digests = exported_assets.merge(rails_app.config.assets.digests)
    end
    def _inject_v4
      rails_app.assets_manifest ||= _empty_manifest_data
      rails_app.assets_manifest = {
        ASSETS_KEY => exported_assets.merge(rails_app.assets_manifest[ASSETS_KEY]),
        FILES_KEY => exported_files.merge(rails_app.assets_manifest[FILES_KEY])
      }
    end
  end
end
