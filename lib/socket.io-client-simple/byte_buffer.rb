module SocketIO
  module Client
    module Simple

      def self.as_byte_buffer(data)
        ByteBuffer.new(data)
      end

      class ByteBuffer
        attr_accessor :buffer

        def initialize(byte_array)
          return unless byte_array.is_a?(Array)
          @buffer = byte_array.unshift(4).pack('C*')
        end
      end
    end
  end
end
