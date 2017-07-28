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
end

unless EmberCli.skip?
  task "assets:precompile" => "ember:compile"
end
