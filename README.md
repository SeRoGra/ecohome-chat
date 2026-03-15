# EcoHome Store — Chat Interno Corporativo

Stack: **Express.js** · **Socket.IO** · **PostgreSQL** · **JWT** · **React 18** · **Docker Compose**

## Arquitectura

```
ecohome-chat/
├── ecohome-chat-backend/    ← Express.js + Socket.IO + PostgreSQL
├── ecohome-chat-frontend/   ← React 18 + socket.io-client
└── README.md
```

## Inicio rápido

```bash
# 1 — Base de datos + backend (Docker)
cd ecohome-chat-backend
docker-compose up -d --build

# 2 — Frontend
cd ecohome-chat-frontend
npm install
npm start   # React en http://localhost:3000
```

El backend queda disponible en `http://localhost:8080`.

## Usuarios de prueba (password: `password123`)

| Usuario | Rol |
|---------|-----|
| ventas_admin | VENTAS |
| logistica_op | LOGISTICA |
| soporte_01 | SOPORTE |

## Socket.IO — Comunicación en tiempo real

| Evento | Dirección | Payload |
|--------|-----------|---------|
| `connect` | Cliente → Servidor | `auth: { token }` (JWT en handshake) |
| `messages` | Servidor → Cliente | Últimos 10 mensajes al conectar |
| `new-message` | Cliente → Servidor | `{ text }` |
| `new-message` | Servidor → Todos | `{ id, userId, username, text, role, createdAt }` |

## API REST

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| POST | `/api/auth/login` | No | Autenticación, retorna JWT |
| POST | `/api/auth/register` | No | Registro de usuario |
| GET | `/api/chat/history` | JWT | Últimos 10 mensajes |
| GET | `/health` | No | Health check |
