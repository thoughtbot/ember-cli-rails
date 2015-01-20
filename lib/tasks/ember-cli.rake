namespace "ember-cli" do
  desc "Runs `ember test` for each App"
  task test: :environment do
    EmberCLI.run_tests!
  end

  desc "Installs each EmberCLI app's dependencies"
  task install_dependencies: :environment do
    EmberCLI.install_dependencies!
  end
end
