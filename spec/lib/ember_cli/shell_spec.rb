require "ember-cli-rails"
require "tmpdir"

describe EmberCli::Shell do
  describe "#compile" do
    let(:log) { Tempfile.new("log") }
    let(:paths) { double(root: Dir.tmpdir, log: log.path) }

    subject { described_class.new(paths: paths) }

    before do
      allow(subject).to \
        receive_message_chain(:ember, :build).and_return(command)
    end

    context "when build succeeds" do
      let(:command) { "echo stdout && echo stderr > /dev/stderr && exit 0" }

      it "silences stdout" do
        stdout = capture(:stdout) { subject.compile }
        expect(stdout).to be_blank
      end

      it "silences stderr" do
        stderr = capture(:stderr) { subject.compile }
        expect(stderr).to be_blank
      end

      it "captures both stderr and stdout to a log" do
        subject.compile
        expect(File.read(log)).to eq("stdout\nstderr\n")
      end

      it "subsequent runs do not append to log" do
        subject.compile
        subject.compile
        expect(File.read(log)).to eq("stdout\nstderr\n")
      end
    end

    context "when build fails" do
      let(:command) { "echo stdout && echo stderr > /dev/stderr && exit 1" }

      it "exits, and outputs captured stdout and stderr to stderr" do
        stderr = capture(:stderr) do
          expect(-> { subject.compile }).to raise_exception(SystemExit)
        end
        expect(stderr).to eq(<<-OUTPUT.strip_heredoc)
          command has failed: #{command}
          command output:
          stdout
          stderr
        OUTPUT
      end

      it "silences stdout" do
        stdout = capture(:stdout) do
          expect(-> { subject.compile }).to raise_exception(SystemExit)
        end
        expect(stdout).to be_blank
      end
    end
  end
end
