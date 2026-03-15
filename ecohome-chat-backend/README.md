# EcoHome Chat — Backend

Servidor Node.js con **Express.js**, **Socket.IO** y **PostgreSQL** para el chat corporativo en tiempo real.

## Tecnologías

- **Express.js 4** — Servidor HTTP y rutas REST
- **Socket.IO 4** — WebSocket bidireccional con reconexión automática
- **PostgreSQL 16** — Persistencia de usuarios y mensajes
- **JWT** (`jsonwebtoken`) — Autenticación stateless
- **BCrypt** (`bcryptjs`) — Hashing de contraseñas (cost 12)
- **Docker Compose** — Orquestación de servicios

## Estructura del proyecto

```
src/
├── index.js            ← Entry point: Express + HTTP + Socket.IO
├── config/
│   └── db.js           ← Pool de conexiones PostgreSQL (pg)
├── middleware/
│   └── auth.js         ← Middleware JWT para rutas protegidas
├── routes/
│   ├── auth.js         ← POST /api/auth/login, /register
│   └── chat.js         ← GET /api/chat/history
├── socket/
│   └── chat.js         ← Handler Socket.IO: handshake JWT, eventos
└── utils/
    └── jwt.js          ← generateToken / verifyToken
db/
└── init.sql            ← Esquema + datos seed (3 usuarios)
```

## Ejecución con Docker

```bash
docker-compose up -d --build
```

Levanta PostgreSQL (puerto 5432) y el backend (puerto 8080).

## Ejecución local (desarrollo)

```bash
# Requiere PostgreSQL corriendo en localhost:5432
npm install
npm run dev    # usa nodemon para hot-reload
```

## Variables de entorno (.env)

| Variable | Default | Descripción |
|----------|---------|-------------|
| `PORT` | 8080 | Puerto del servidor |
| `DB_HOST` | localhost | Host de PostgreSQL |
| `DB_PORT` | 5432 | Puerto de PostgreSQL |
| `DB_NAME` | ecohome_chat | Nombre de la base de datos |
| `DB_USER` | ecohome_user | Usuario de BD |
| `DB_PASSWORD` | ecohome_pass | Contraseña de BD |
| `JWT_SECRET` | — | Clave secreta para firmar tokens |
| `JWT_EXPIRATION` | 86400000 | Expiración del token (ms) |
| `CORS_ORIGIN` | http://localhost:3000 | Origen permitido para CORS |

## API REST

### POST `/api/auth/login`
```json
// Request
{ "username": "ventas_admin", "password": "password123" }

// Response 200
{ "token": "eyJ...", "username": "ventas_admin", "role": "VENTAS" }
```

### POST `/api/auth/register`
```json
// Request
{ "username": "nuevo", "email": "nuevo@ecohome.co", "password": "mipass", "role": "USER" }

// Response 201
{ "token": null, "username": "nuevo", "role": "USER" }
```

### GET `/api/chat/history`
Header: `Authorization: Bearer <token>`

Retorna los últimos 10 mensajes ordenados cronológicamente.

## Socket.IO

Conexión con JWT en el handshake:
```javascript
const socket = io('http://localhost:8080', {
  auth: { token: '<JWT>' }
});
```

### Eventos

| Evento | Dirección | Descripción |
|--------|-----------|-------------|
| `messages` | Server → Client | Historial (10 últimos) al conectar |
| `new-message` | Client → Server | Enviar mensaje: `{ text }` |
| `new-message` | Server → Todos | Broadcast: `{ id, userId, username, text, role, createdAt }` |

## Base de datos

Dos tablas: `users` y `messages`. El esquema se inicializa automáticamente con `db/init.sql` al crear el contenedor de PostgreSQL.

Usuarios seed (password: `password123`):
- `ventas_admin` (VENTAS)
- `logistica_op` (LOGISTICA)
- `soporte_01` (SOPORTE)
