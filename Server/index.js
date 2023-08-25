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

// Function to find or create a namespace and connect the user
function findOrCreateNamespace(socket) {
  let namespace;

  // Check for available namespaces or create a new one
  for (const ns of namespaces) {
    if (ns.users.length < MAX_USERS_PER_NAMESPACE) {
      namespace = ns;
      break;
    }
  }

  if (!namespace) {
    namespace = createNamespace();
  }

  // Connect the user to the selected namespace
  connectToNamespace(socket, namespace);
}

// Function to connect a user to a namespace
function connectToNamespace(socket, namespace) {
  namespace.users.push(socket.id);
  socket.join(namespace.name);
  socket.emit('userConnected', namespace.name);

  // Notify all users on the namespace about the new user
  socket.to(namespace.name).emit('userJoined', socket.id);

  // Check if there are enough users for a game
  if (namespace.users.length === MAX_USERS_PER_NAMESPACE) {
    startGame(namespace);
  }
}

// Function to start a game when enough users are present in a namespace
function startGame(namespace) {
  // Notify all users on the namespace that a game has started
  io.in(namespace.name).emit('gameStarted', namespace.name);
}

// Function to handle user disconnect
function handleDisconnect(socket) {
  // Display the current state of all namespaces
  console.log('\n');
  for (const ns of namespaces) {
    console.log(`=> Current namespace ${ns.name}: , count: ${ns.users.length}`);
  }
  console.log('\n');

  const namespaceName = findNamespaceByUser(socket.id);

  if (namespaceName) {
    // Notify other users on the namespace about the disconnect
    socket.to(namespaceName).emit('userDisconnected', socket.id);
    // io.to(namespaceName).emit('userDisconnected', socket.id);

    console.log(`=> A User disconnected`);

    // Remove the user from the namespace
    const namespace = namespaces.find(ns => ns.name === namespaceName);
    const index = namespace.users.indexOf(socket.id);

    if (index !== -1) {
      namespace.users.splice(index, 1);
    }

    // If there are no users left in the namespace, remove it
    if (namespace.users.length === 0) {
      const namespaceIndex = namespaces.indexOf(namespace);
      namespaces.splice(namespaceIndex, 1);
    }

    // Check if there are any namespaces with only one user
    checkForSingleUserNamespaces();
  }
}

// Function to find a namespace by user
function findNamespaceByUser(userId) {
  for (const ns of namespaces) {
    if (ns.users.includes(userId)) {
      return ns.name;
    }
  }
  return null;
}

// Function to check for namespaces with only one user and merge them
function checkForSingleUserNamespaces() {
  const singleUserNamespaces = namespaces.filter(ns => ns.users.length === 1);

  while (singleUserNamespaces.length >= 2) {
    const namespace1 = singleUserNamespaces.pop();
    const namespace2 = singleUserNamespaces.pop();
    console.log(`=> Processing namespace ${namespace1.name}: , count: ${namespace1.users.length}`);
    console.log(`=> Processing namespace ${namespace2.name}: , count: ${namespace2.users.length}`);

    // Merge the two namespaces
    const mergedNamespace = createNamespace();
    for (const socketId of namespace1.users) {
      console.log(`=> Processing ${socketId}`)
      console.log(`=> Connected number of sockets: # ${io.of(namespace1.name).sockets.size}`);
      const socket = io.of(namespace1.name).sockets.get[socketId];
      if (socket) {
        console.log(`=> Preconnect1 namespace ${mergedNamespace.name}: , count: ${mergedNamespace.users.length}`);
        connectToNamespace(socket, mergedNamespace);
      } else {
        console.log(`=> Socket1 not found to merge`);
      }
    }
    for (const socketId of namespace2.users) {
      const socket = io.sockets.sockets[socketId];
      if (socket) {
        console.log(`=> Preconnect2 namespace ${mergedNamespace.name}: , count: ${mergedNamespace.users.length}`);
        connectToNamespace(socket, mergedNamespace);
      } else {
        console.log(`=> Socket1 not found to merge`);
      }
    }
  }
}


// Event handler for user connections
io.on('connection', (socket) => {
  console.log(`=> A User connected`);

  // Display the current state of all namespaces
  console.log('\n');
  for (const ns of namespaces) {
    console.log(`=> Current namespace ${ns.name}: , count: ${ns.users.length}`);
  }
  console.log('\n');

  // Find or create a namespace and connect the user
  findOrCreateNamespace(socket);

  // Display the current state of all namespaces
  for (const ns of namespaces) {
    console.log(`=> Updated namespace ${ns.name}: , count: ${ns.users.length}`);
  }

  // Handle user disconnect
  socket.on('disconnect', () => {
    handleDisconnect(socket);
  });
});

// Function to create a new namespace
function createNamespace() {
  const name = `namespace_${namespaces.length + 1}`;
  const users = [];
  namespaces.push({ name, users });
  console.log(`=> New namespace created: ${name}`);

  // Display the current state of all namespaces
  console.log('\n');
  for (const ns of namespaces) {
    console.log(`=> Current namespace ${ns.name}: , count: ${ns.users.length}`);
  }
  console.log('\n');

  return { name, users };
}
