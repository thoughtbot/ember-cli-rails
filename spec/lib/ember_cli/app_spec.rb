require "ember-cli-rails"

describe EmberCli::App do
  describe "#compile" do
    it "exits with exit status of 0" do
      passed = EmberCli["my-app"].compile

      expect(passed).to be true
    end
  end

  describe "#test" do
    it "exits with exit status of 0" do
      passed = EmberCli["my-app"].test

      expect(passed).to be true
    end
  end

  describe "#root" do
    it "delegates to PathSet" do
      root_path = Pathname(".")
      allow_any_instance_of(EmberCli::PathSet).
        to receive(:root).
        and_return(root_path)
      app = EmberCli::App.new("foo")

      root = app.root

      expect(root).to eq root_path
    end
  end
end
