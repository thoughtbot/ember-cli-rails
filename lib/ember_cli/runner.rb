require "open3"

module EmberCli
  class Runner
    def initialize(out:, err:, env: {}, options: {})
      @env = env
      @out_streams = Array(out)
      @err_streams = Array(err)
      @options = options
    end

    def run(command)
      output, status = Open3.capture2e(env, command, options)

      write_to_out(output)

      [output, status]
    end

    def run!(command)
      output, status = run(command)

      unless status.success?
        write_to_err <<-MSG.strip_heredoc
          ERROR: Failed command: `#{command}`
          OUTPUT:
            #{output}
        MSG

        exit status.exitstatus
      end

      true
    end

    protected

    attr_reader :env, :err_streams, :options, :out_streams

    private

    def write_to_out(output)
      write(out_streams, output)
    end

    def write_to_err(output)
      write(out_streams + err_streams, output)
    end

    def write(streams, output)
      streams.each do |stream|
        stream.write(output)
      end
    end
  end
end
