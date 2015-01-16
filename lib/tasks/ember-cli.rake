namespace "ember-cli" do
  desc "Installs each EmberCLI app's dependencies"
  task install_dependencies: :environment do
    EmberCLI.install_dependencies!
  end
end
