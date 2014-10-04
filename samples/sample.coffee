#!/usr/bin/env coffee
## npm insatll socket.io-client coffee-script

url    = process.argv[2] or 'http://localhost:3000'
socket = require('socket.io-client').connect url, {transports: ['websocket']}

socket.on 'connect', ->
  console.log 'connect!!'

socket.on 'disconnect', ->
  console.log 'disconnected'

socket.on 'chat', (data) ->
  console.log "> " + data.msg

process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (data) ->
  msg = data.replace(/[\r\n]/g, '')
  return if msg.length < 1
  socket.emit 'chat', {msg: msg, at: Date.now()}
