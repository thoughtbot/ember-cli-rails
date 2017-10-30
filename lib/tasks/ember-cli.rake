namespace :ember do
  desc "Runs `ember build` for each App"
  task compile: :install do
    EmberCli.compile!
  end

  desc "Runs `ember test` for each App"
  task test: :environment do
    EmberCli.test!
  end

  desc "Installs each EmberCLI app's dependencies"
  task install: :environment do
    EmberCli.install_dependencies!
  end

  desc "Updates config/environment.js tests configuration"
  task update_test_environment: :environment do
    EmberCli.update_test_env_configurations!
  end

  task update_test_environment_with_mirage: :environment do
    EmberCli.update_test_env_configurations!(mirage: true)
  end
end

unless EmberCli.skip?
  task "assets:precompile" => "ember:compile"
end
