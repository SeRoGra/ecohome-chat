# EcoHome Chat — Frontend

Aplicación **React 18** con **socket.io-client** para el chat corporativo en tiempo real de EcoHome Store.

## Tecnologías

- **React 18** — UI con hooks y lazy loading
- **socket.io-client 4** — Comunicación WebSocket con reconexión automática
- **React Router 6** — Navegación SPA
- **CSS custom** — Diseño inspirado en Slack/Discord con tema oscuro

## Estructura del proyecto

```
src/
├── App.jsx                 ← Router principal con lazy loading
├── components/
│   ├── LoginScreen.jsx     ← Formulario de login/registro
│   ├── LoginScreen.css
│   ├── ChatScreen.jsx      ← Chat principal: sidebar + mensajes + input
│   └── ChatScreen.css
├── hooks/
│   └── useSocket.js        ← Hook Socket.IO: conexión, eventos, envío
└── index.js
```

## Ejecución

```bash
npm install
npm start       # Desarrollo en http://localhost:3000
npm run build   # Build de producción
```

## Variables de entorno (.env)

| Variable | Default | Descripción |
|----------|---------|-------------|
| `REACT_APP_API_URL` | http://localhost:8080 | URL del backend |

## Funcionalidades

- **Login/Registro** — Autenticación JWT contra el backend
- **Chat en tiempo real** — Mensajes vía Socket.IO con broadcast
- **Historial** — Últimos 10 mensajes cargados al conectar
- **Indicador de conexión** — Pill verde/rojo según estado del socket
- **Avatares por rol** — Colores diferenciados: Ventas (verde), Logística (azul), Soporte (amarillo)
- **Separadores de fecha** — Agrupa mensajes por día (Hoy, Ayer, fecha)
- **Persistencia de sesión** — Token y datos de usuario en localStorage

## Hook `useSocket`

```javascript
const { messages, connected, error, sendMessage } = useSocket(token);
```

- `messages` — Array de mensajes (historial + tiempo real)
- `connected` — Estado de conexión Socket.IO
- `error` — Error de conexión (si hay)
- `sendMessage(text)` — Emite `new-message` al servidor
