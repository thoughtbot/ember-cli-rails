module EmberCli
  module Helpers
    extend self

    def which(cmd)
      exts = ENV.fetch("PATHEXT", ";").split(";", -1).uniq

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
      if Rails.configuration.respond_to?(key)
        Rails.configuration.public_send(key)
      else
        yield
      end
    end
  end
end
