require "ember_cli/shell"

describe EmberCli::Shell do
  describe "#install" do
    it "runs the yarn install command" do
      paths = build_paths
      shell = build_shell(paths: paths)

      expect_runner_to(:run, "/path/to/ember version").
        and_return(double(success?: true))
      expect_runner_to(:run!, "/path/to/yarn install ")

      shell.install
    end

    context "when passing install_command_line_arguments" do
      it "passes it to the command" do
        paths = build_paths
        shell = build_shell(
          paths: paths,
          options: { install_command_line_arguments: "--frozen-lockfile" },
        )

        expect_runner_to(:run, "/path/to/ember version").
          and_return(double(success?: true))
        expect_runner_to(:run!, "/path/to/yarn install --frozen-lockfile")

        shell.install
      end
    end
  end

  def expect_runner_to(method_name, command_line)
    expect_any_instance_of(EmberCli::Runner).
      to receive(method_name).with(command_line)
  end

  def build_paths
    double(
      gemfile: double(exist?: false),
      yarn: "/path/to/yarn",
      bower_json: double(exist?: false),
      ember: "/path/to/ember",
    ).as_null_object
  end

  def build_shell(**options)
    EmberCli::Shell.new(options)
  end
end
