require "monitor"

module Capture
  def capture(stream)
    stream_monitor.synchronize do
      begin
        stream = stream.to_s
        captured_stream = Tempfile.new(stream)
        stream_io = Object.const_get(stream.upcase)
        origin_stream = stream_io.dup
        stream_io.reopen(captured_stream)

        yield

        stream_io.rewind
        return captured_stream.read
      ensure
        captured_stream.close
        captured_stream.unlink
        stream_io.reopen(origin_stream)
      end
    end
  end

  def stream_monitor
    @stream_monitor ||= Monitor.new
  end
end

RSpec.configure { |c| c.include Capture }
