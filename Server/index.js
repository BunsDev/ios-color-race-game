
const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const app = express();
const server = http.createServer(app);
const io = socketIO(server);
const PORT = 3000;
const MAX_USERS_PER_NAMESPACE = 2;
const namespaces = [];

server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

io.on('connection', (socket) => {

  console.log(`=> A User connected`);

  for (const ns of namespaces) {
    console.log(`=> Current namespace ${ns.name}: , count: ${ns.users.length}`);
  }


  let namespace;
  for (const ns of namespaces) {
    if (ns.users.length < MAX_USERS_PER_NAMESPACE) {
      namespace = ns;
      console.log(`=> Available namespace found: ${namespace}`);
      break;
    }
  }

  if (!namespace) {
    console.log(`=> No available namespace found !`);
    namespace = createNamespace();
    console.log(`=> New namespace created: ${namespace.name}`);
  }

  console.log(`=> Proceeding with namespace: ${namespace.name}, count: ${namespace.users.length}`);

  namespace.users.push(socket.id);

  console.log(`=> Pushed user onto namespace: ${namespace.name}, count: ${namespace.users.length}`);


  console.log(`=> Joining user to namespace: ${namespace.name}, count: ${namespace.users.length}`);
  socket.join(namespace.name);

  socket.emit('userConnected', namespace.name);
  console.log(`=> Emitting 'userConnected' to namespace: ${namespace.name}, count: ${namespace.users.length}`);

  socket.emit('namespaceAssigned', namespace.name);
  console.log(`=> Emitting 'namespaceAssigned' to namespace: ${namespace.name}, count: ${namespace.users.length}`);

  socket.on('disconnectNamespace', (namespaceName) => {

    console.log(`=> Disconnecting from namespace ${namespaceName}`);

        const targetNamespace = namespaces.find((namespace) => namespace.name === namespaceName);

        if (targetNamespace) {

          console.log(`=> Found namespace to disconnect from: ${targetNamespace.name}, count: ${targetNamespace.users.length}`);

            const index = targetNamespace.users.indexOf(socket.id);
            console.log(`=> Searching disconnecting user to disconnect from namespace: ${targetNamespace.name}`);

            if (index !== -1) {
              
              // notify other users on namespace of user disconnection
              const message = `${socket.id} has disconnected.`;
              socket.to(namespaceName).emit('userDisconnected', message);
              console.log(`=> Emitting 'userDisconnected' to namespace: ${namespace.name}, count: ${namespace.users.length}`);

              console.log(`=> Found disconnecting user in namespace: ${targetNamespace.name}, count: ${targetNamespace.users.length}`);

                targetNamespace.users.splice(index, 1);
                console.log(`=> Disconnected user from namespace: ${targetNamespace.name}, count: ${targetNamespace.users.length}`);
                
                if (targetNamespace.users.length === 0) {
                  console.log(`=> No more users connected to namespace: ${targetNamespace.name}, count: ${targetNamespace.users.length}`);
                    const indexToRemove = namespaces.indexOf(targetNamespace);
                    console.log(`=> Searching namespace to clear from namespaces: ${targetNamespace.name}, namespaces count: ${namespaces.length}`);

                    if (indexToRemove !== -1) {
                        namespaces.splice(indexToRemove, 1);
                        console.log(`=> Namespace ${namespaceName} removed due to no users.`);
                        console.log(`=> Updated name space count count: ${namespaces.length}`);
                    }
                }
            }
        }
    });

// TODO: If at any point, there are exactly 1 user on multiple namespaces, match them with each other and clear empty namespaces

  if(namespace.users.length == MAX_USERS_PER_NAMESPACE) {
    console.log(`=> Enough members for game in namespace: ${namespace.name}, count: ${namespace.users.length}`);
    // notify current socket
    socket.emit('foundOpponent')
    // notify other sockets on same namespace
    socket.to(namespace.name).emit('foundOpponent');
    console.log(`=> Emitting 'foundOpponent' to namespace: ${namespace.name}, count: ${namespace.users.length}`);
  }
});

function createNamespace() {
  const name = `namespace_${namespaces.length + 1}`;
  const users = [];
  namespaces.push({ name, users });

  // io.of(`/${name}`).on('connection', (socket) => {
  //   console.log(`=> User connected to ${name}: ${socket.id}`);
  // });

  return { name, users };
}