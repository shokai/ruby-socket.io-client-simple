var io = require('socket.io').listen(3000);

io.sockets.on('connection', function(socket){
  socket.emit('chat', {msg: 'hello world (from server)'});
  socket.on('chat', function(data){
    console.log(data);
    socket.emit('chat', data); // echo
  });
});
