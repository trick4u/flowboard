const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const http = require('http');
const socketIo = require('socket.io');
const commentRoutes = require('./routes/commentRoutes');
const activityRoutes = require('./routes/activityRoutes');

dotenv.config();
const app = express();
app.use('/api/comments', commentRoutes);
app.use('/api/activities', activityRoutes);
app.use(cors());
app.use(express.json());

// Routes
const authRoutes = require('./routes/authRoutes');
const boardRoutes = require('./routes/boardRoutes');
const listRoutes = require('./routes/listRoutes');
const taskRoutes = require('./routes/taskRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/boards', boardRoutes);
app.use('/api/lists', listRoutes);
app.use('/api/tasks', taskRoutes);

const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: '*', // adjust for production
    methods: ['GET', 'POST']
  }
});

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch((err) => console.log(err));

// Start Server
const PORT = process.env.PORT || 5001;


// Socket.IO connection
io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);

  socket.on('joinBoard', (boardId) => {
    socket.join(boardId);
  });

  socket.on('taskUpdated', ({ boardId, task }) => {
    socket.to(boardId).emit('taskUpdated', task);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });

  socket.on('newComment', ({ boardId, comment }) => {
    socket.to(boardId).emit('newComment', comment);
  });

  socket.on('newActivity', ({ boardId, activity }) => {
    socket.to(boardId).emit('newActivity', activity);
  });
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});