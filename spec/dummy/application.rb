require "rails"

require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __FILE__).freeze
    config.eager_load = false

    # Show full error reports and disable caching.
    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    # Raise exceptions instead of rendering exception templates.
    config.action_dispatch.show_exceptions = false

    # Randomize the order test cases are executed.
    config.active_support.test_order = :random

    # Print deprecation notices to the stderr.
    config.active_support.deprecation = :stderr

    config.assets.enabled = true
    config.assets.debug = true
    config.assets.digest = true
    config.assets.raise_runtime_errors = true
    config.assets.version = "1.0"

    config.secret_token = "SECRET_TOKEN_IS_MIN_30_CHARS_LONG"
    config.secret_key_base = "SECRET_KEY_BASE"

    def require_environment!
      initialize!
    end
  end
end
