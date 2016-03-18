require "ember_cli/runner"

describe EmberCli::Runner do
  describe "#run!" do
    context "when the command fails" do
      it "writes output to `out` streams" do
        output_streams = Array.new(2) { StringIO.new }
        runner = EmberCli::Runner.new(
          err: [],
          out: output_streams,
        )

        expect { runner.run!("echo 'out'; echo 'err' > /dev/stderr; exit 1") }.
          to raise_error(SystemExit)

        ouput_strings = output_streams.each(&:rewind).map(&:read)

        ouput_strings.each do |output|
          expect(output).to eq("out\n")
        end
      end

      it "writes errors to `err` streams" do
        error_streams = Array.new(2) { StringIO.new }
        runner = EmberCli::Runner.new(
          err: error_streams,
          out: [],
        )

        expect { runner.run!("echo 'out'; echo 'err' > /dev/stderr; exit 1") }.
          to raise_error(SystemExit)

        error_strings = error_streams.each(&:rewind).map(&:read)

        error_strings.each do |error|
          expect(error).to eq("err\n")
        end
      end
    end

    it "executes the command" do
      out = StringIO.new
      err = StringIO.new
      runner = EmberCli::Runner.new(err: [err], out: [out])

      status = runner.run!("echo 'out'")

      [err, out].each(&:rewind)

      expect(status).to be_success
      expect(err.read).to be_empty
      expect(out.read).to eq("out\n")
    end
  end
end
