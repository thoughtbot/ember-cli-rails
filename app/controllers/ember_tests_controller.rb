class EmberTestsController < ActionController::Base
  def index
    render text: test_html_with_corrected_asset_urls, layout: false
  end

  private

  def test_html_with_corrected_asset_urls
    test_html.gsub(%r{assets/}i, "#{asset_prefix}/#{app_name}/")
  end

  def test_html
    tests_index_path.read
  end

  def tests_index_path
    app.tests_path.join("index.html")
  end

  def app
    EmberCli[app_name]
  end

  def app_name
    params.fetch(:app_name)
  end

  def asset_prefix
    Rails.configuration.assets.prefix
  end
end
