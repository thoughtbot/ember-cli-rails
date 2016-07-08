require "ember_cli/multi_constraint"

describe EmberCli::MultiConstraint do
  subject(:multi_constraint) { described_class.new(child_1, child_2) }
  let(:child_1) { double("Route Constraint") }
  let(:child_2) { double("Route Constraint") }
  let(:request) { instance_double("ActionDispatch::Request") }

  describe "#matches?" do

    it "is true when all constraints match" do
      allow(child_1).to receive(:matches?).with(request) { true }
      allow(child_2).to receive(:matches?).with(request) { true }

      expect(multi_constraint.matches?(request)).to be true
    end

    it "is false when any constraint fails to match" do
      allow(child_1).to receive(:matches?).with(request) { true }
      allow(child_2).to receive(:matches?).with(request) { false }

      expect(multi_constraint.matches?(request)).to be false
    end
  end
end
