## socket.io chat server

process.env.PORT ||= 3000;

io = require('socket.io').listen process.env.PORT
console.log "socket.io server start - port: #{process.env.PORT}"

io.sockets.on 'connection', (socket) ->
  user = socket.handshake.query.user
  socket.emit 'chat', {msg: 'hello world (from server)'}
  socket.on 'chat', (data) ->
    console.log data
    data.user = user
    io.sockets.emit 'chat', data; # broadcast echo

if process.env.EXIT_AT
  setTimeout ->
    process.exit();
  , process.env.EXIT_AT-0
