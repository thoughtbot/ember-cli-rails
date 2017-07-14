require "ember-cli-rails"

describe EmberCli::App do
  describe "#to_rack" do
    it "delegates to `#deploy`" do
      deploy = double(to_rack: :delegated)
      app = EmberCli["my-app"]
      allow(app).to receive(:deploy).and_return(deploy)

      to_rack = app.to_rack

      expect(to_rack).to be :delegated
    end
  end

  describe "#mountable?" do
    it "delegates to `#deploy`" do
      deploy = double(mountable?: :delegated)
      app = EmberCli["my-app"]
      allow(app).to receive(:deploy).and_return(deploy)

      mountable = app.mountable?

      expect(mountable).to be :delegated
    end
  end

  describe "yarn_enabled?" do
    context "when configured with yarn: true" do
      it "returns true" do
        app = EmberCli::App.new("with-yarn", yarn: true)

        yarn_enabled = app.yarn_enabled?

        expect(yarn_enabled).to be true
      end
    end

    context "when configured with yarn: false" do
      it "returns false" do
        app = EmberCli::App.new("without-yarn", yarn: false)

        yarn_enabled = app.yarn_enabled?

        expect(yarn_enabled).to be false
      end
    end
  end

  describe "#bower?" do
    context "when bower.json exists" do
      it "returns true" do
        bower_json_path = double("Pathname", exist?: true)
        stub_paths(bower_json: bower_json_path)
        app = EmberCli::App.new("with bower json")

        bower_required = app.bower?

        expect(bower_required).to be true
      end
    end

    context "when bower.json is absent" do
      it "returns false" do
        bower_json_path = double("Pathname", exist?: false)
        stub_paths(bower_json: bower_json_path)
        app = EmberCli::App.new("without bower json")

        bower_required = app.bower?

        expect(bower_required).to be false
      end
    end
  end

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

  describe "#root_path" do
    it "delegates to PathSet" do
      root_path = Pathname.new(".")
      stub_paths(root: root_path)
      app = EmberCli::App.new("foo")

      root_path = app.root_path

      expect(root_path).to eq root_path
    end
  end

  describe "#dist_path" do
    it "delegates to PathSet" do
      dist_path = Pathname.new(".")
      stub_paths(dist: dist_path)
      app = EmberCli::App.new("foo")

      dist_path = app.dist_path

      expect(dist_path).to eq dist_path
    end
  end

  def stub_paths(method_to_value)
    allow_any_instance_of(EmberCli::PathSet).
      to receive(method_to_value.keys.first).
      and_return(method_to_value.values.first)
  end
end
