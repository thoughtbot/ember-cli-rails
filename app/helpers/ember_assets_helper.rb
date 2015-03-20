module EmberAssetsHelper
  def ember_cli_rails_assets(app_name)
    assets = {}

    rails_asset_extensions = EmberCLI.get_app(app_name).rails_asset_extensions

    Rails.application.config.assets.paths.each do |assets_path|
      rails_asset_extensions.each do |file_ext|
        Dir[File.join(assets_path, "**", "*#{file_ext}")].each do |absolute_path|
          file = absolute_path.sub(File.join(assets_path, '/'), '')
          assets[file] = asset_url(file)
        end
      end
    end

    assets
  end

  def include_ember_cli_rails_assets(app_name)
    content_tag "script", "window.EMBER_CLI_RAILS_ASSETS = #{raw(ember_cli_rails_assets(app_name).to_json)}".html_safe
  end
end
