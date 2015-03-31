module EmberCLI
  class AppWin < EmberCLI::App

    def ember_path
      @ember_path ||= app_path.join("node_modules", ".bin", "ember").tap do |path|
        fail <<-MSG.strip_heredoc unless path.exist?
          No local ember executable found. You should run `npm install`
          inside the #{name} app located at #{app_path}
        MSG
      end
    end

    def symlink_to_assets_root
      exec ("cmd.exe /c \"mklink /J #{assets_path.join(name).to_s.gsub('/', '\\')} #{dist_path.join("assets").to_s.gsub('/', '\\')}\"")
    rescue Errno::EEXIST
      # Sometimes happens when starting multiple Unicorn workers.
      # Ignoring...
    end

    def command(options={})
      watch = options[:watch] ? "--watch" : ""

      "\"#{ember_path}.cmd\" build #{watch} --environment #{environment} --output-path \"#{dist_path}\" #{log_pipe}"
    end

    def log_pipe
      "| \"#{tee_path}\" -a \"#{log_path}\"" if tee_path
    end

  end
end
