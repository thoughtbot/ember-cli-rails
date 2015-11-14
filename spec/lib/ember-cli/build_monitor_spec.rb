require "ember-cli/errors"
require "ember-cli/build_monitor"

describe EmberCli::BuildMonitor do
  describe "#reset" do
    context "when there is a build error" do
      it "deletes the build file" do
        error_file = error_file_with_contents
        paths = build_paths(error_file)
        monitor = EmberCli::BuildMonitor.new(nil, paths)

        monitor.reset

        expect(error_file).to have_received(:delete)
      end
    end

    context "when there is not a build error" do
      it "does nothing" do
        error_file = missing_error_file
        paths = build_paths(error_file)
        monitor = EmberCli::BuildMonitor.new(nil, paths)

        monitor.reset

        expect(error_file).not_to have_received(:delete)
      end
    end
  end

  describe "#check!" do
    context "when the error file has content" do
      it "raises a BuildError" do
        paths = build_paths(error_file_with_contents(["first-line"]))
        monitor = EmberCli::BuildMonitor.new("app-name", paths)

        expect { monitor.check! }.
          to raise_error(
            EmberCli::BuildError,
            %{"app-name" has failed to build: first-line},
          )
      end
    end

    context "when the error file exists but is empty" do
      it "does not raise a BuildError" do
        paths = build_paths(blank_error_file)
        monitor = EmberCli::BuildMonitor.new(nil, paths)

        expect(monitor.check!).to be true
      end
    end

    context "when the error file is missing" do
      it "does not raise a BuildError" do
        paths = build_paths(missing_error_file)
        monitor = EmberCli::BuildMonitor.new(nil, paths)

        expect(monitor.check!).to be true
      end
    end
  end

  def build_paths(error_file)
    double(build_error_file: error_file)
  end

  def error_file_with_contents(contents = ["foo"])
    build_error_file(exist?: true, size?: true, readlines: contents)
  end

  def blank_error_file
    build_error_file(exist?: true, size?: false)
  end

  def missing_error_file
    build_error_file(exist?: false)
  end

  def build_error_file(**options)
    double(**options).tap do |stub|
      allow(stub).to receive(:delete)
    end
  end
end
