# EcoHome Store — Backend Centralizado + Frontend React

Stack: **Express.js** · **Socket.IO** · **PostgreSQL** · **JWT** · **React 18** · **Docker Compose**

> **Unidad 3**: este proyecto es el **backend centralizado** que consume tanto la app React como la app Flutter. Se agregaron endpoints de productos con trazabilidad (creador) y estadísticas por usuario.

## Arquitectura

```
ecohome-chat/
├── ecohome-chat-backend/    ← Express.js + Socket.IO + PostgreSQL
│   └── src/routes/
│       ├── auth.js          ← /api/auth/login, /register
│       ├── chat.js          ← /api/chat/history
│       ├── products.js      ← /api/products (CRUD + trazabilidad) [U3]
│       └── users.js         ← /api/users/me/stats [U3]
├── ecohome-chat-frontend/   ← React 18 + socket.io-client
│   └── src/components/
│       ├── ChatScreen.jsx   ← Chat en tiempo real
│       └── ProductsScreen.jsx ← Catálogo con creador y contador [U3]
└── README.md
```

## Inicio rápido

```bash
# 1 — Base de datos + backend (Docker)
cd ecohome-chat-backend
docker-compose up -d --build

# 2 — Frontend React
cd ecohome-chat-frontend
npm install
npm start   # React en http://localhost:3000
```

El backend queda disponible en `http://localhost:8080`.

## Endpoints disponibles

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| POST | `/api/auth/login` | — | Login con JWT |
| POST | `/api/auth/register` | — | Registro de usuario |
| GET | `/api/chat/history` | JWT | Últimos 10 mensajes |
| GET | `/api/products` | JWT | Lista productos con creador |
| POST | `/api/products` | JWT | Crea producto (creador=JWT) |
| PUT | `/api/products/:id` | JWT | Actualiza producto |
| DELETE | `/api/products/:id` | JWT | Elimina producto |
| GET | `/api/users/me/stats` | JWT | Stats del usuario `{username, role, product_count}` |

## Usuarios de prueba (password: `password123`)

| Usuario | Rol |
|---------|-----|
| `ventas_admin` | VENTAS |
| `logistica_op` | LOGISTICA |
| `soporte_01`   | SOPORTE |

## Socket.IO — Comunicación en tiempo real

| Evento | Dirección | Payload |
|--------|-----------|---------|
| `messages` | Server → Client | Historial de 10 mensajes al conectar |
| `new-message` | Client → Server | `{ text }` — enviar mensaje |
| `new-message` | Server → Todos | `{ id, userId, username, text, role, createdAt }` |

Conexión con JWT en el handshake:
```javascript
const socket = io('http://localhost:8080', { auth: { token: '<JWT>' } });
```
