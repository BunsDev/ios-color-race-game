const express = require('express')
const app = express();
const http = require('http').Server(app)
const io = require('socket.io')(http)
const port = 3000

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

    socket.on('disconnect', function() {
        console.log('someone disconnected!');
    });
});