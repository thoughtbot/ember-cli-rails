require "ember_cli/command"
require "ember_cli/runner"

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
      run! ember.build
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
        run! "#{paths.bundler} install"
      end

      if invalid_ember_dependencies?
        clean_ember_dependencies!
      end

      if paths.yarn
        run! "#{paths.yarn} install"
      else
        run! "#{paths.npm} prune && #{paths.npm} install"
      end

      if paths.bower_json.exist?
        run! "#{paths.bower} prune && #{paths.bower} install"
      end
    end

    def test
      run! ember.test
    end

    private

    attr_accessor :pid
    attr_reader :ember, :env, :options, :paths

    delegate :run, :run!, to: :runner

    def invalid_ember_dependencies?
      !run("#{paths.ember} version").success?
    rescue DependencyError
      false
    end

    def clean_ember_dependencies!
      ember_dependency_directories.flat_map(&:children).each(&:rmtree)
    end

    def ember_dependency_directories
      [
        paths.node_modules,
        paths.bower_components,
      ].select(&:exist?)
    end

    def spawn(command)
      Kernel.spawn(
        env,
        command,
        chdir: paths.root.to_s,
        err: paths.build_error_file.to_s,
      ) || exit(1)
    end

    def runner
      Runner.new(
        options: { chdir: paths.root.to_s },
        out: [$stdout, paths.log.open("a")],
        err: [$stderr],
        env: env,
      )
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
  end
end
