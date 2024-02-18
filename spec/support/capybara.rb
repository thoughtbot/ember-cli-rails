require "selenium/webdriver"

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(
      args: %w[--no-sandbox --headless],
    ),
  )
end

Capybara.server = :webrick
Capybara.javascript_driver = :headless_chrome
