module EmberCli
  module Helpers
    extend self

    def match_version?(version, requirements)
      version = Gem::Version.new(version)

      Array.wrap(requirements).any? do |requirement|
        requirement = Gem::Requirement.new(requirement)
        requirement.satisfied_by?(version)
      end
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

    def current_environment
      rails_config_for(:ember_cli_rails_mode){ default_environment }.to_s
    end

    private

    def default_environment
      if Rails.env.test?
        "test"
      elsif Rails.env.production? || !rails_config_for(:consider_all_requests_local)
        "production"
      else
        "development"
      end
    end

    def rails_config_for(key)
      config = Rails.configuration
      config.respond_to?(key) ? config.public_send(key) : yield
    end
  end
end
