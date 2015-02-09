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
      !Rails.env.production? && rails_config_for(:consider_all_requests_local)
    end

    def use_middleware?
      rails_config_for(:use_ember_middleware, non_production?)
    end

    def use_live_recompilation?
      rails_config_for(:use_ember_live_recompilation, Rails.env.development?)
    end

    def rails_config_for(key, default=false)
      config = Rails.configuration
      config.respond_to?(key) ? config.public_send(key) : default
    end
  end
end
