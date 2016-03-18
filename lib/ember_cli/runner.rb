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
      output, error, status = Open3.capture3(env, command, options)

      write(output, streams: out_streams)
      write(error, streams: err_streams)

      status
    end

    def run!(command)
      run(command).tap do |status|
        unless status.success?
          exit status.exitstatus
        end
      end
    end

    protected

    attr_reader :env, :err_streams, :options, :out_streams

    private

    def write(output, streams:)
      streams.each do |stream|
        stream.write(output)
      end
    end
  end
end
