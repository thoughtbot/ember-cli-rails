require "spec_helper"
require "ember-cli/deploy"

describe EmberCLI::Deploy do
  describe "#append_to_head" do
    it "injects the string into the <head> tag" do
      provided_html = "<html><head></head></html>"
      ember_cli_deploy = build_ember_cli_deploy(index_html: provided_html)

      ember_cli_deploy.append_to_head("<script></script>")
      index_html = ember_cli_deploy.html

      expect(index_html).to eq("<html><head><script></script></head></html>")
    end
  end

  describe "#append_to_body" do
    it "injects the string into the <body> tag" do
      provided_html = "<html><body></body></html>"
      ember_cli_deploy = build_ember_cli_deploy(index_html: provided_html)

      ember_cli_deploy.append_to_body("<script></script>")
      index_html = ember_cli_deploy.html

      expect(index_html).to eq("<html><body><script></script></body></html>")
    end
  end

  describe "#html" do
    context "when the HTML is provided" do
      it "returns the HTML" do
        provided_html = "<p>Hello World</p>"
        ember_cli_deploy = build_ember_cli_deploy(index_html: provided_html)

        index_html = ember_cli_deploy.html

        expect(index_html).to eq(provided_html)
      end
    end

    context "when the keys are present" do
      it "retrieves the HTML from Redis" do
        stub_index_html(html: "<p>Hello World</p>")
        ember_cli_deploy = build_ember_cli_deploy

        index_html = ember_cli_deploy.html

        expect(index_html).to eq("<p>Hello World</p>")
      end
    end

    context "when the current index is missing" do
      it "raises a helpful exception" do
        deploy_key = "#{namespace}:abc123"
        stub_index_html(html: nil, deploy_key: deploy_key)
        ember_cli_deploy = build_ember_cli_deploy

        expect { ember_cli_deploy.html }.to raise_error(
          /HTML for #{deploy_key} is missing/
        )
      end
    end

    context "when the current key is unset" do
      it "raises a helpful exception" do
        stub_current_key(nil)
        ember_cli_deploy = build_ember_cli_deploy

        expect { ember_cli_deploy.html }.to raise_error(
          /#{namespace}:current is empty/
        )
      end
    end
  end

  around :each do |example|
    with_modified_env REDIS_URL: "redis://localhost:1234" do
      example.run
    end
  end

  def build_ember_cli_deploy(index_html: nil)
    EmberCLI::Deploy.new(namespace: namespace, index_html: index_html)
  end

  def namespace
    "human-health"
  end

  def stub_current_key(deploy_key)
    current_key = "#{namespace}:current"

    redis.set(current_key, deploy_key)
  end

  def stub_index_html(deploy_key: "#{namespace}:123", html:)
    stub_current_key(deploy_key)
    redis.set(deploy_key, html)
  end

  def redis
    Redis.new(url: ENV["REDIS_URL"])
  end

  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end
end
