$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'socket.io-client-simple'

client = SocketIO::Client::Simple.connect 'http://localhost:3000'

client.on :chat do |data|
  puts "chat > #{data['msg']}"
end

client.websocket.on :message do |msg|
  p msg.data
end

client.on :connect do
  puts "connect!!!"
end

client.on :disconnect do
  puts "disconnected!!"
end

loop do
  msg = STDIN.gets.strip
  next if msg.empty?
  client.emit :chat, {:msg => msg, :at => Time.now}
  sleep 1
end

