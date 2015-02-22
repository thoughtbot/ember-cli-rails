class EmberTestsController < ActionController::Base
  def index
    render text: test_html_with_corrected_asset_urls, layout: false
  end

  private

  def test_html_with_corrected_asset_urls
    test_html.gsub(%r{assets/}i, "assets/#{app_name}/")
  end

  def test_html
    tests_index_path.read
  end

  def tests_index_path
    app.tests_path.join("index.html")
  end

  def app
    EmberCLI.get_app(app_name)
  end

  def app_name
    params.fetch(:app_name)
  end
end
