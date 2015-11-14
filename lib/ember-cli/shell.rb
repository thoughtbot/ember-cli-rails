require "ember-cli/command"

module EmberCli
  class Shell
    def initialize(paths:, env: {}, options: {})
      @paths = paths
      @env = env
      @ember = Command.new(
        paths: paths,
        options: options,
      )
      @on_exit ||= at_exit { stop }
    end

    def compile
      silence_build { exec ember.build }
    end

    def build_and_watch
      unless running?
        lock_buildfile
        self.pid = spawn ember.build(watch: true)
        detach
      end
    end

    def stop
      if pid.present?
        Process.kill(:INT, pid)
        self.pid = nil
      end
    end

    def install
      if paths.gemfile.exist?
        exec "#{paths.bundler} install"
      end

      exec "#{paths.npm} prune && #{paths.npm} install"
      exec "#{paths.bower} prune && #{paths.bower} install"
    end

    def test
      exec ember.test
    end

    private

    attr_accessor :pid
    attr_reader :ember, :env, :options, :paths

    def spawn(command)
      exec(command, method: :spawn)
    end

    def exec(command, method: :system)
      Dir.chdir paths.root do
        Kernel.public_send(method, env, command, err: :out) || exit(1)
      end
    end

    def running?
      pid.present? && Process.getpgid(pid)
    rescue Errno::ESRCH
      false
    end

    def lock_buildfile
      FileUtils.touch(paths.lockfile)
    end

    def detach
      Process.detach pid
    end

    def silence_build(&block)
      if ENV.fetch("EMBER_CLI_RAILS_VERBOSE") { EmberCli.env.production? }
        yield
      else
        silence_stream(STDOUT, &block)
      end
    end
  end
end
