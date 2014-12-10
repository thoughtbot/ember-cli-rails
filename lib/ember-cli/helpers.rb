module EmberCLI
  module Helpers
    extend self

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
      !Rails.env.production? && Rails.configuration.consider_all_requests_local
    end

    def override_assets_precompile_task!
      Rake.application.instance_eval do
        @tasks["assets:precompile:original"] = @tasks.delete("assets:precompile")
        Rake::Task.define_task "assets:precompile", [:assets, :precompile] => :environment do
          EmberCLI.compile!
          Rake::Task["assets:precompile:original"].execute
        end
      end
    end
  end
end
