$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'socket.io-client-simple'

url    = ARGV.shift or 'http://localhost:3000'
socket = SocketIO::Client::Simple.connect url

# socket.auto_reconnection = false

#socket.websocket.on :message do |msg|  ## inspect websocket data
#  p msg.data
#end

socket.on :connect do
  puts "connect!!!"
end

socket.on :disconnect do
  puts "disconnected!!"
end

socket.on :chat do |data|
  puts "> " + data['msg']
end

socket.on :error do |err|
  p err
end

puts "please input and press Enter key"
loop do
  msg = STDIN.gets.strip
  next if msg.empty?
  socket.emit :chat, {:msg => msg, :at => Time.now}
end
