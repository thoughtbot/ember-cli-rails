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

      true
    end

    def reset
      if build_error_output?
        error_file.delete
      end
    end

    def wait!
      loop do
        check!
        break if complete?
        sleep 0.1
      end
    end

    private

    attr_reader :name, :paths

    def complete?
      !paths.lockfile.exist?
    end

    def build_error_output?
      error_file.exist? && error_file.size?
    end

    def build_error?
      return false unless build_error_output?
      lines = error_file.readlines
      # Filter out blank and backtrace lines (leaving just messages):
      lines.reject! { |line| line =~ /(^\s*$|^\s{4}at .+$)/ }
      # Filter out any deprecation warnings (allowing for ASCII color escape
      # codes at the start of the line):
      lines.reject! { |line| line =~ /^(\e[^\s]+)?DEPRECATION:/ }

      # There was a build error if any lines remain:
      lines.any?
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
