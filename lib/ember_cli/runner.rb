require "open3"

module EmberCli
  class Runner
    def initialize(env: {}, out:, err:, options: {})
      @env = env
      @out = out
      @err = err
      @options = options
    end

    def run!(command)
      output, status = Open3.capture2e(@env, command, @options)

      @out.write(output)

      unless status.success?
        @err.write <<-MSG.strip_heredoc
          ERROR: Failed command: `#{command}`
          OUTPUT:
            #{output}
        MSG

        exit 1
      end

      true
    end
  end
end
