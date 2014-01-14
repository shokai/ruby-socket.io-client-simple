require 'json'
require 'httparty'
require 'websocket-client-simple'
require 'event_emitter'

require 'socket.io-client-simple/version'
require 'socket.io-client-simple/error'
require 'socket.io-client-simple/client'

module SocketIO
  module Client
    module Simple

      def self.connect(url)
        Client.new(url)
      end

    end
  end
end
