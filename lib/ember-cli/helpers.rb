module EmberCLI
  module Helpers
    extend self

    def match_version?(version, requirement)
      version = Gem::Version.new(version)
      requirement = Gem::Requirement.new(requirement)
      requirement.satisfied_by?(version)
    end

    def which(cmd)
      exts = ENV.fetch("PATHEXT", ?;).split(?;, -1).uniq

      ENV.fetch("PATH").split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end

      nil
    end

    def non_production?
      rails_config_for(:use_ember_middleware) ||
      (!Rails.env.production? && rails_config_for(:consider_all_requests_local))
    end

    def live_recompilation?
      rails_config_for(:use_ember_live_recompilation) || Rails.env.development?
    end

    def rails_config_for(key)
      Rails.configuration.respond_to?(key) and Rails.configuration.send(key)
    end

    def override_assets_precompile_task!
      Rake.application.instance_eval do
        @tasks["assets:precompile:original"] = @tasks.delete("assets:precompile")
        Rake::Task.define_task "assets:precompile", [:assets, :precompile] => "ember-cli:install_dependencies" do
          EmberCLI.compile!
          Rake::Task["assets:precompile:original"].execute
        end
      end
    end
  end
end
