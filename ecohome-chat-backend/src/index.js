require('dotenv').config();

const express        = require('express');
const http           = require('http');
const cors           = require('cors');
const morgan         = require('morgan');
const authRouter     = require('./routes/auth');
const chatRouter     = require('./routes/chat');
const { initSocket } = require('./socket/chat');

const app    = express();
const server = http.createServer(app);

// Middleware
app.use(cors({ origin: process.env.CORS_ORIGIN || 'http://localhost:3000', credentials: true }));
app.use(express.json());
app.use(morgan('dev'));

// Rutas REST
app.use('/api/auth', authRouter);
app.use('/api/chat', chatRouter);

// Health check
app.get('/health', (_req, res) => res.json({ status: 'UP' }));

// Socket.IO
initSocket(server);

// Iniciar servidor
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`EcoHome Chat Backend corriendo en puerto ${PORT}`);
  console.log(`Socket.IO listo para conexiones`);
});
