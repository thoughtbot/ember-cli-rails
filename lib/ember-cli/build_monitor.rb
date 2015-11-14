module EmberCli
  class BuildMonitor
    def initialize(name, paths)
      @name = name
      @paths = paths
    end

    def check!
      if build_error?
        raise_build_error!
      end
    end

    def reset
      if build_error?
        error_file.delete
      end
    end

    private

    attr_reader :name, :paths

    def build_error?
      error_file.exist? && error_file.size?
    end

    def error_file
      paths.build_error_file
    end

    def raise_build_error!
      backtrace = error_file.readlines.reject(&:blank?)
      message = "#{name.inspect} has failed to build: #{backtrace.first}"

      error = BuildError.new(message)
      error.set_backtrace(backtrace)

      fail error
    end
  end
end
