require "active_support/core_ext/object/blank"
require "ember-cli/page"

module EmberCLI
  class Deploy
    def initialize(namespace:, index_html: nil)
      @namespace = namespace
      @index_html = index_html
      @body_markup = []
      @head_markup = []
    end

    def append_to_body(markup)
      body_markup << markup
    end

    def append_to_head(markup)
      head_markup << markup
    end

    def html
      if index_html.present?
        page = Page.new(html: index_html)

        body_markup.each do |markup|
          page.append_to_body(markup)
        end

        head_markup.each do |markup|
          page.append_to_head(markup)
        end

        page.build
      else
        index_html_missing!
      end
    end

    private

    attr_reader :body_markup, :head_markup, :namespace

    def index_html
      @index_html ||= redis.get(deploy_key).presence
    end

    def current_key
      "#{namespace}:current"
    end

    def deploy_key
      redis.get(current_key).presence || deployment_not_activated!
    end

    def redis
      Redis.new(url: ENV.fetch("REDIS_URL"))
    end

    def index_html_missing!
      message = <<-FAIL
        HTML for #{deploy_key} is missing.

        Did you forget to call `ember deploy`?
      FAIL

      raise KeyError, message
    end

    def deployment_not_activated!
      message = <<-FAIL
        #{current_key} is empty.

        Did you forget to call `ember deploy:activate`?
      FAIL

      raise KeyError, message
    end
  end
end
