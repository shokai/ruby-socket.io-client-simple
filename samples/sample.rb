$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'socket.io-client-simple'

client = SocketIO::Client::Simple.connect 'http://localhost:3000'

#client.on :chat do |data|
#  puts "> #{data.inspect}"
#end
#
#client.on :connect do
#  puts "connect!!!"
#end
#
#client.on :disconnect do
#  puts "disconnected!!"
#end

loop do
  client.emit :chat, {:msg => 'hello!! from client'}
  sleep 1
end

