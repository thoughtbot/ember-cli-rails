require "rails/generators"
require "generator_spec"
require "generators/ember/heroku/heroku_generator"

describe EmberCli::HerokuGenerator, type: :generator do
  destination Rails.root.join("tmp", "generator_test_output")

  context "without yarn enabled" do
    it "does not generate a root-level yarn.lock" do
      EmberCli.configure { |c| c.app "my-app", yarn: false }
      setup_destination

      run_generator

      expect(destination_root).to have_structure {
        no_file "yarn.lock"
      }
    end
  end

  context "with yarn enabled" do
    it "generates a root-level yarn.lock" do
      EmberCli.configure { |c| c.app "my-app", yarn: true }
      setup_destination

      run_generator

      expect(destination_root).to have_structure {
        file "yarn.lock"
      }
    end
  end

  def setup_destination
    prepare_destination

    create_empty_gemfile_for_bundler
  end

  def create_empty_gemfile_for_bundler
    FileUtils.touch(destination_root.join("Gemfile"))
  end
end
