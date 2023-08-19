const express = require('express')
const app = express()
const http = require('http').Server(app)
const io = require('socket.io')(http)
const port = 3000
var users = 0

// app.listen(port, function() {
//     console.log(`App running on http://localhost:${port}`)
// })

app.get("/", function(request, response) {
    console.log(`Server listening on port ${port}`)
    response.sendFile(__dirname + "/index.html")
})

http.listen(port, function() {
    console.log(`App running on http://localhost:${port}`)
})

io.on('connection', function(socket) {
    console.log('someone connected!');

    users++
    // emit message to all connected users
    // io.sockets.emit('broadcastActiveUsers', { message: users + " connected"})

    // emit message to new connections
    socket.emit('newUser', { message: "Welcome!"})

    // emit message to existing connections
    socket.broadcast.emit('newUser', { message: users + " connected"})

    socket.on('disconnect', function() {
        console.log('someone disconnected!');

        users--

        // emit message to all connected users
        // io.sockets.emit('broadcastActiveUsers', { message: users + " connected"})

        // emit message to existing connections
        socket.broadcast.emit('newUser', { message: users + " connected"})
    });
});