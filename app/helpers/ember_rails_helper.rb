require "ember_cli/capture"

module EmberRailsHelper
  def include_ember_index_html(name, &block)
    Warnings.warn_include_index_html

    render_ember_app(name, &block)
  end

  def render_ember_app(name, &block)
    markup_capturer = EmberCli::Capture.new(sprockets: self, &block)

    head, body = markup_capturer.capture

    render inline: EmberCli[name].index_html(head: head, body: body)
  end

  def include_ember_script_tags(name, **options)
    Warnings.warn_asset_helper

    javascript_include_tag(*EmberCli[name].sprockets.javascript_assets, options)
  end

  def include_ember_stylesheet_tags(name, **options)
    Warnings.warn_asset_helper

    stylesheet_link_tag(*EmberCli[name].sprockets.stylesheet_assets, options)
  end

  module Warnings
    def self.warn_include_index_html
      warn <<-MSG.strip_heredoc
        The `include_ember_index_html` helper has been deprecated.

        Rename all invocations to `render_ember_app`
      MSG
    end

    def self.warn_asset_helper
      if Rails::VERSION::MAJOR < 4
        warn <<-MSG.strip_heredoc
          `ember-cli-rails` no longer supports Sprockets-based helpers for Rails
          versions below 4.0.

          Replace usage of
            * `include_ember_script_tags`
            * `include_ember_stylesheet_tags`

          with `render_ember_app` invocations.

          To learn more, please read:

          * https://github.com/thoughtbot/ember-cli-rails#configuring-the-ember-controller
          * https://github.com/thoughtbot/ember-cli-rails/pull/316
        MSG
      end
    end
  end
end
