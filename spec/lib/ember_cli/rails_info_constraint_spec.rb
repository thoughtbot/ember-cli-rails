require "ember_cli/rails_info_constraint"

describe EmberCli::RailsInfoConstraint do
  subject(:constraint) { described_class.new }

  describe "#matches?" do
    context %{when the path doesn't start with "/rails/info"} do
      it "return true" do
        rails_only_request = double(fullpath: "/rails")
        railroads_request = double(fullpath: "/rails/roads")

        expect(constraint.matches?(rails_only_request)).to be true
        expect(constraint.matches?(railroads_request)).to be true
      end
    end

    context %{when the path starts with "/rails/info"} do
      it "return false" do
        info_request = double(fullpath: "/rails/info")
        properties_request = double(fullpath: "/rails/info/properties")
        routes_request = double(fullpath: "/rails/info/routes")

        expect(constraint.matches?(info_request)).to be false
        expect(constraint.matches?(properties_request)).to be false
        expect(constraint.matches?(routes_request)).to be false
      end
    end
  end
end
