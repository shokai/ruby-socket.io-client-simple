# SocketIO::Client::Simple
A simple ruby client for node.js's socket.io. Supports only WebSocket.

- https://github.com/shokai/ruby-socket.io-client-simple
- https://rubygems.org/gems/ruby-socket.io-client-simple


## Install

    % gem install socket.io-client-simple


## Usage

[samples/sample.rb](https://github.com/shokai/ruby-socket.io-client-simple/blob/master/samples/sample.rb)
```ruby
require 'rubygems'
require 'socket.io-client-simple'

client = SocketIO::Client::Simple.connect 'http://localhost:3000'

client.on :connect do
  puts "connect!!!"
end

client.on :disconnect do
  puts "disconnected!!"
end

client.on :chat do |data|
  puts ">" + data['msg']
end

loop do
  msg = "hello!!"
  client.emit :chat, {:msg => msg, :at => Time.now}
  sleep 1
end
```

sample.rb works with [samples/chat_server.js](https://github.com/shokai/ruby-socket.io-client-simple/blob/master/samples/chat_server.js).

### start chat server

    % npm install socket.io
    % node samples/chat_server.js

=> chat server start at localhost:3000


### ruby sample.rb

    % ruby samples/sample.rb


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
