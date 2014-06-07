# SocketIO::Client::Simple
A simple ruby client for node.js's socket.io. Supports only WebSocket.

- https://github.com/shokai/ruby-socket.io-client-simple
- https://rubygems.org/gems/socket.io-client-simple

[![Travis-CI Build Status](https://travis-ci.org/shokai/ruby-socket.io-client-simple.png?branch=master)](https://travis-ci.org/shokai/ruby-socket.io-client-simple)

## Install

    % gem install socket.io-client-simple


## Usage

[samples/sample.rb](https://github.com/shokai/ruby-socket.io-client-simple/blob/master/samples/sample.rb)
```ruby
require 'rubygems'
require 'socket.io-client-simple'

socket = SocketIO::Client::Simple.connect 'http://localhost:3000'

## connect with parameter
socket = SocketIO::Client::Simple.connect 'http://localhost:3000', :foo => "bar"

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
```

sample.rb works with [samples/chat_server.js](https://github.com/shokai/ruby-socket.io-client-simple/blob/master/samples/chat_server.js).

### start chat server

    % npm install
    % node samples/chat_server.js

=> chat server start at localhost:3000


### ruby sample.rb

    % ruby samples/sample.rb

## Test

    % gem install bundler
    % bundle install
    % npm install
    % bundle exec rake test


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
