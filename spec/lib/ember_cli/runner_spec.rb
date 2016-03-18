require "ember_cli/runner"

describe EmberCli::Runner do
  describe "#run!" do
    context "when the command fails" do
      it "writes to all `err` and `out` streams" do
        output_streams = Array.new(4) { StringIO.new }
        runner = EmberCli::Runner.new(
          err: output_streams.first(2),
          out: output_streams.last(2),
        )

        expect { runner.run!("echo 'out'; echo 'err' > /dev/stderr; exit 1") }.
          to raise_error(SystemExit)

        output_streams.each(&:rewind)

        output_streams.each do |stream|
          expect(stream.read).to match(/out\nerr/)
        end
      end
    end

    it "executes the command" do
      out = StringIO.new
      err = StringIO.new
      runner = EmberCli::Runner.new(err: [err], out: [out])

      runner.run!("echo 'out'")

      [err, out].each(&:rewind)

      expect(err.read).to be_empty
      expect(out.read).to eq("out\n")
    end
  end
end
