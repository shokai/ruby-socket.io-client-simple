module SocketIO
  module Client
    module Simple

      class Client
        def initialize(url)
          configure url
        end

        def configure(url)
          @url = url
          res = HTTParty.get "#{@url}/socket.io/1/"
          raise res.body unless res.code == 200

          arr = res.body.split(':')
          @session_id = arr.shift
          @heartbeat_timeout = arr.shift.to_i
          @connection_timeout = arr.shift.to_i
          @transports = arr.shift.split(',')
          @options = arr.shift || {}
          unless @transports.include? 'websocket'
            raise Error, "server #{@url} does not supports websocket!!"
          end

          @ws = WebSocket::Client::Simple.connect "#{url}/socket.io/1/websocket/#{@session_id}"
          that = self
          @ws.on :open do
            that.emit :connect
          end
          @ws.on :close do
            that.emit :disconnect
          end
        end

        def emit(event_name, data)
          emit_data = {:name => event_name, :args => [data]}.to_json
          @ws.send "5:::#{emit_data}"
        end

      end

    end
  end
end
