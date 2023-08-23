
const express = require('express');
const http = require('http');
const socketIO = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIO(server);

const PORT = 3000;

server.listen(PORT, () => {
  console.log(`1. Server is running on port ${PORT}`);
});

const MAX_USERS_PER_NAMESPACE = 2;
const namespaces = [];

io.on('connection', (socket) => {

  console.log(`2 => A User connected`);

  for (const ns of namespaces) {
    console.log(`3 => Current namespace ${ns.name}: , count: ${ns.users.length}`);
  }


  let namespace;
  for (const ns of namespaces) {
    if (ns.users.length < MAX_USERS_PER_NAMESPACE) {
      namespace = ns;
      console.log(`4 => Available namespace found: ${namespace}`);
      break;
    }
  }

  if (!namespace) {
    console.log(`5 => No available namespace found !`);
    namespace = createNamespace();
    console.log(`6 => New namespace created: ${namespace.name}`);
  }

  console.log(`7 => Proceeding with namespace: ${namespace.name}, count: ${namespace.users.length}`);

  namespace.users.push(socket.id);

  console.log(`8 => Pushed user onto namespace: ${namespace.name}, count: ${namespace.users.length}`);


  console.log(`9 => Joining user to namespace: ${namespace.name}, count: ${namespace.users.length}`);
  socket.join(namespace.name);

  socket.emit('userConnected', namespace.name);
  console.log(`10 => Emitting 'userConnected' to namespace: ${namespace.name}, count: ${namespace.users.length}`);

  socket.emit('namespaceAssigned', namespace.name);
  console.log(`11 => Emitting 'namespaceAssigned' to namespace: ${namespace.name}, count: ${namespace.users.length}`);

  if(namespace.users.length == MAX_USERS_PER_NAMESPACE) {
    console.log(`12 => Enough members for game in namespace: ${namespace.name}, count: ${namespace.users.length}`);
    // TODO: check for way to emit to current socket without explicitly doing so.
    socket.emit('foundOpponent')
    socket.broadcast.emit('foundOpponent')
    console.log(`13 => Emitting 'foundOpponent' to namespace: ${namespace.name}, count: ${namespace.users.length}`);
  }

});

function createNamespace() {
  const name = `namespace_${namespaces.length + 1}`;
  const users = [];
  namespaces.push({ name, users });

  io.of(`/${name}`).on('connection', (socket) => {
    console.log(`14 => User connected to ${name}: ${socket.id}`);

    // TODO: Fix count updation on socket disconnection from a namespace
    socket.on('disconnect', () => {
      const index = namespace.users.indexOf(socket.id);
      if (index !== -1) {
        namespace.users.splice(index, 1);
      }
      console.log(`15 => User disconnected from ${name}: ${socket.id}`);
    });
  });

  return { name, users };
}