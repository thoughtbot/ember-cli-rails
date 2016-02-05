describe "GET assets/my-app.js" do
  it "responds with the 'Cache-Control' header from Rails" do
    build_ember_cli_assets

    get "/assets/my-app.js"

    expect(headers["Cache-Control"]).to eq(cache_for_five_minutes)
  end

  def build_ember_cli_assets
    EmberCli["my-app"].build
  end

  def cache_for_five_minutes
    Dummy::Application::CACHE_CONTROL_FIVE_MINUTES
  end
end
