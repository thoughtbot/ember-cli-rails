require "ember_cli/ember_constraint"

describe EmberCli::EmberConstraint do
  describe "#matches?" do
    context %{when the format is "html"} do
      context "when the request path is for a Rails active storage file" do
        it "returns a falsey value" do
          constraint = EmberCli::EmberConstraint.new
          request = build_html_request("/rails/active_storage")

          expect(constraint.matches?(request)).to be_falsey
        end
      end

      context "when the request path is for a Rails info page" do
        it "returns a falsey value" do
          constraint = EmberCli::EmberConstraint.new
          request = build_html_request("/rails/info")

          expect(constraint.matches?(request)).to be_falsey
        end
      end

      context "when the request path is not for a Rails info page" do
        it "returns a truthy value" do
          constraint = EmberCli::EmberConstraint.new
          request = build_html_request("/foo")

          expect(constraint.matches?(request)).to be_truthy
        end
      end
    end

    context %{when the format isn't "html"} do
      it "return false" do
        constraint = EmberCli::EmberConstraint.new
        request = build_json_request

        expect(constraint.matches?(request)).to be_falsey
      end
    end
  end

  def build_request(format:, fullpath: :ignored)
    double(format: format ? Mime::Type.new(format) : nil, fullpath: fullpath)
  end

  def build_html_request(fullpath)
    build_request(format: :html, fullpath: fullpath)
  end

  def build_json_request
    build_request(format: :json)
  end
end
