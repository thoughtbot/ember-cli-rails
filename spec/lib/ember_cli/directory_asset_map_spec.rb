require "tmpdir"
require "fileutils"
require "ember_cli/directory_asset_map"

describe EmberCli::DirectoryAssetMap do
  describe "#to_h" do
    it "represents the directory" do
      create_file("first")
      create_file("second")
      create_file("third")

      directory_manifest = EmberCli::DirectoryAssetMap.new(directory).to_h

      expect(directory_manifest["prepend"]).to eq("assets/")
      expect(directory_manifest["assets"]).to match a_hash_including(
        "first" => "first",
        "second" => "second",
        "third" => "third",
      )
    end
  end

  def create_file(name)
    path = directory.join(name)

    FileUtils.touch(path)

    File.new(path)
  end

  def directory
    @directory ||= Pathname(Dir.mktmpdir)
  end
end
