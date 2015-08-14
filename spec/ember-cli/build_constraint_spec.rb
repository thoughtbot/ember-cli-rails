require "ember-cli/build_constraint"

describe EmberCli::BuildConstraint do
  describe "#enabled?" do
    context "when #block is nil" do
      it "returns true" do
        constraint = EmberCli::BuildConstraint.new(
          block: nil,
          request: build_request,
        )

        expect(constraint.enabled?).to be true
      end
    end

    context "when passed no arguments" do
      it "captures the return value" do
        invoked = false
        constraint = EmberCli::BuildConstraint.new(
          request: build_request,
          block: lambda do
            invoked = true
          end,
        )

        expect(constraint.enabled?).to be true
        expect(invoked).to be true
      end
    end

    context "when passed a single argument" do
      it "invokes the block with the path" do
        path = nil
        constraint = EmberCli::BuildConstraint.new(
          request: build_request("path"),
          block: lambda do |p|
            path = p
            :returned
          end,
        )

        expect(constraint.enabled?).to be :returned
        expect(path).to eq "path"
      end
    end

    context "when passed two arguments" do
      it "invokes the block with the path and Rack env" do
        path = nil
        request = nil
        constraint = EmberCli::BuildConstraint.new(
          request: build_request("new-path"),
          block: lambda do |p, e|
            path = p
            request = e
            :returned
          end,
        )

        expect(constraint.enabled?).to be :returned
        expect(path).to eq "new-path"
        expect(request.env).to eq build_request("new-path").env
      end
    end

    def build_request(path = "old-path")
      Rack::Request.new(
        "PATH_INFO" => path,
      )
    end
  end
end
