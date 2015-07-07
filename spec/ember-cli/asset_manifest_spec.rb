require 'ember-cli/asset_manifest'

describe EmberCLI::AssetManifest do
  let(:name) { :frontend }
  subject(:manifest) { described_class.new( :frontend ) }

  it "has basic path properties" do
    expect(subject.asset_dist_path).to eq "#{Rails.root}/public/assets/#{name}"
  end

  context "when no manifest is present" do
    before do
      subject.load_manifest_data
    end

    it "loads an empty manifiest data" do
      expect(subject.data).to have_key(described_class::ASSETS_KEY)
      expect(subject.data).to have_key(described_class::FILES_KEY)
    end
  end

  context "when a manifest is present" do
    before do
      subject.stub(:asset_dist_path) { File.dirname(__FILE__) }
    end
    it { expect(subject.manifest_file_path).not_to be_nil }
    context "that is loaded" do
      before do
        subject.load_manifest_data
      end
      it "memoizes loaded data" do
        expect(subject.data[described_class::ASSETS_KEY].keys).not_to be_empty
      end
    end
  end

  context "in a Rails 3 application" do
    before do
      Rails.application = Rails3::Application.new
    end
    it { expect(described_class.assets_version).to be 3 }
    it "can inject data" do
      subject.inject_manifest
    end
  end

  context "in a Rails 4 application" do
    before do
      Rails.application = Rails4::Application.new
    end
    it { expect(described_class.assets_version).to be 4 }
    it "can inject data" do
      subject.inject_manifest
    end
  end
end
