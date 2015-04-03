namespace :ember do
  desc "Runs `ember build` for each App"
  task compile: :install do
    EmberCLI.compile!
  end

  desc "Runs `ember test` for each App"
  task test: :environment do
    EmberCLI.run_tests!
  end

  desc "Installs each EmberCLI app's dependencies"
  task install: :environment do
    EmberCLI.install_dependencies!
  end
end

task "assets:precompile" => "ember:compile" unless EmberCLI.skip?
