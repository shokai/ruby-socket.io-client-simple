// socket.io chat server
var port = (process.env.PORT || 3000) - 0;

var io = require('socket.io').listen(port);
console.log("socket.io server start - port:"+port);

io.sockets.on('connection', function(socket){
  socket.emit('chat', {msg: 'hello world (from server)'});
  socket.on('chat', function(data){
    console.log(data);
    socket.emit('chat', data); // echo
  });
});


if(!!process.env.EXIT_AT){
  setTimeout(function(){
    process.exit();
  }, process.env.EXIT_AT-0);
}
