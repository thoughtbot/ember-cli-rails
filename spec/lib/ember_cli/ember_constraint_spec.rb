require "ember_cli/ember_constraint"

describe EmberCli::EmberConstraint do
  describe "#matches?" do
    context %{when the format is "html"} do
      context "when the request path is for a Rails info page" do
        it "returns false" do
          constraint = EmberCli::EmberConstraint.new
          request = build_html_request("/rails/info")

          expect(constraint.matches?(request)).to be false
        end
      end

      context "when the request path is not for a Rails info page" do
        it "returns true" do
          constraint = EmberCli::EmberConstraint.new
          request = build_html_request("/foo")

          expect(constraint.matches?(request)).to be true
        end
      end
    end

    context %{when the format isn't "html"} do
      it "return false" do
        constraint = EmberCli::EmberConstraint.new
        request = build_json_request

        expect(constraint.matches?(request)).to be false
      end
    end

    context %"when the format is empty or nil" do
      it "return false" do
        constraint = EmberCli::EmberConstraint.new
        nil_request = build_request(format: nil)
        empty_request = build_request(format: "")

        expect(constraint.matches?(nil_request)).to be false
        expect(constraint.matches?(empty_request)).to be false
      end
    end
  end

  def build_request(format:, fullpath: :ignored)
    double(format: format, fullpath: fullpath)
  end

  def build_html_request(fullpath)
    build_request(format: :html, fullpath: fullpath)
  end

  def build_json_request
    build_request(format: :json)
  end
end
