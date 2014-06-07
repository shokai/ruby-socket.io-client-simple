module SocketIO
  module Client
    module Simple

      def self.connect(url, opts={})
        client = Client.new(url, opts)
        client.connect
        return client
      end

      class Client
        include EventEmitter
        alias_method :__emit, :emit

        attr_accessor :auto_reconnection, :websocket, :url, :reconnecting, :state,
                      :session_id, :ping_interval, :ping_timeout, :last_pong_at

        def initialize(url, opts={})
          @url = url
          @opts = opts
          @opts[:transport] = :websocket
          @reconnecting = false
          @state = :disconnect
          @auto_reconnection = true

          Thread.new do
            loop do
              if @state == :connect
                @websocket.send "2"  ## ping
                @last_ping_at = Time.now
                sleep @ping_interval/1000
              else
                sleep 1
              end
            end
          end

        end


        def connect
          query = @opts.map{|k,v| "#{k}=#{v}" }.join '&'
          begin
            @websocket = WebSocket::Client::Simple.connect "#{@url}/socket.io/?#{query}"
          rescue Errno::ECONNREFUSED => e
            @state = :disconnect
            @reconnecting = false
            reconnect
            return
          end

          this = self

          @websocket.on :error do |err|
            if err.kind_of? Errno::ECONNRESET and this.state == :connect
              this.state = :disconnect
              this.__emit :disconnect
              this.reconnect
              next
            end
            this.__emit :error, err
          end

          @websocket.on :message do |msg|
            next unless msg.data =~ /^\d+/
            code, body = msg.data.unpack('U*').pack('C*').force_encoding('utf-8').scan(/^(\d+)(.*)$/)[0]
            code = code.to_i
            case code
            when 0  ##  socket.io connect
              this.reconnecting = false
              body = JSON.parse body rescue next
              this.session_id = body["sid"]
              this.ping_interval = body["pingInterval"]
              this.ping_timeout = body["pingTimeout"]
              this.state = :connect
              this.__emit :connect
            when 3  ## pong
              this.last_pong_at = Time.now
            when 41  ## disconnect from server
              this.websocket.close if this.websocket.open?
              this.state = :disconnect
              this.__emit :disconnect
              reconnect
            when 42  ## data
              data = JSON.parse body rescue next
              event_name = data.shift
              this.__emit event_name, *data
            end
          end

          return self
        end

        def reconnect
          return unless @auto_reconnection
          return if @reconnecting
          @reconnecting = true
          sleep rand(10)+5
          connect
        end

        def open?
          @websocket and @websocket.open?
        end

        def emit(event_name, *data)
          return unless open?
          return unless @state == :connect
          data.unshift event_name
          @websocket.send "42#{data.to_json}".unpack('C*').pack('U*')
        end

      end

    end
  end
end
