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
      ENV.fetch("EMBER_ENV") { default_environment }
    end

    private

    def default_environment
      if Rails.env.match(/test|development/)
        Rails.env
      else
        "production"
      end
    end
  end
end
