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
  # Hook into assets:precompile:all for Rails 3.1+
  if Rails::VERSION::MAJOR < 4
    task "assets:precompile:all" => "ember:compile"
  else
    task "assets:precompile" => "ember:compile"
  end
end
