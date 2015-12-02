require "ember_cli/runner"

describe EmberCli::Runner do
  describe "#run!" do
    context "when the command fails" do
      it "writes STDERR and STDOUT to `err`" do
        out = StringIO.new
        err = StringIO.new
        runner = EmberCli::Runner.new(err: err, out: out)

        expect { runner.run!("echo 'out'; echo 'err' > /dev/stderr; exit 1") }.
          to raise_error(SystemExit)

        [err, out].each(&:rewind)

        expect(err.read).to match(/out\nerr/)
        expect(out.read).to eq("out\nerr\n")
      end
    end

    it "executes the command" do
      out = StringIO.new
      err = StringIO.new
      runner = EmberCli::Runner.new(err: err, out: out)

      runner.run!("echo 'out'")

      [err, out].each(&:rewind)

      expect(err.read).to be_empty
      expect(out.read).to eq("out\n")
    end
  end
end
