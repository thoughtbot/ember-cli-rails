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

unless EmberCLI.skip?
  # Hook into assets:precompile:all for Rails 3.1+
  if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new("4.0.0")
    task "assets:precompile:all" => "ember:compile"
  else
    task "assets:precompile" => "ember:compile"
  end
end
