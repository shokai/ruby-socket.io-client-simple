module SocketIO
  module Client
    module Simple

      class Client
        include EventEmitter
        alias_method :__emit, :emit

        attr_reader :websocket, :session_id, :heartbeat_timeout,
                    :connection_timeout, :transports

        def initialize(url, opts={})
          @url = url
          @opts = opts
          configure

          @websocket = WebSocket::Client::Simple.connect "#{url}/socket.io/1/websocket/#{@session_id}"

          this = self
          @websocket.on :message do |msg|
            code, body = msg.data.scan(/^(\d+):{2,3}(.*)$/)[0]
            code = code.to_i
            case code
            when 0
              this.__emit :disconnect
            when 1
              this.__emit :connect
            when 2
              send "2::"  # heartbeat
            when 3
            when 4
            when 5
              data = JSON.parse body
              this.__emit data['name'], *data['args']
            when 6
            when 7
              this.__emit :error
            end
          end

          @websocket.on :close do
            this.emit :disconnect
          end

          @websocket.send "1::#{opts[:path]}"
        end

        def configure
          res = HTTParty.get "#{@url}/socket.io/1/"
          raise res.body unless res.code == 200

          arr = res.body.split(':')
          @session_id = arr.shift
          @heartbeat_timeout = arr.shift.to_i
          @connection_timeout = arr.shift.to_i
          @transports = arr.shift.split(',')
          unless @transports.include? 'websocket'
            raise Error, "server #{@url} does not supports websocket!!"
          end
        end

        def emit(event_name, *data)
          emit_data = {:name => event_name, :args => data}.to_json
          @websocket.send "5:::#{emit_data}"
        end

      end

    end
  end
end
