-- =============================================
-- EcoHome Chat - Inicializacion de base de datos
-- =============================================

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id         BIGSERIAL    PRIMARY KEY,
    username   VARCHAR(100) NOT NULL UNIQUE,
    email      VARCHAR(200) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    role       VARCHAR(50)  NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- password = 'password123' (BCrypt cost 12)
INSERT INTO users (username, email, password, role) VALUES
('ventas_admin',  'ventas@ecohome.co',    '$2a$12$T4lput4UbPcNAznwEBP4RejmQiddyOOh3AvDNzyyJZUR2C.sAe30.', 'VENTAS'),
('logistica_op',  'logistica@ecohome.co', '$2a$12$T4lput4UbPcNAznwEBP4RejmQiddyOOh3AvDNzyyJZUR2C.sAe30.', 'LOGISTICA'),
('soporte_01',    'soporte@ecohome.co',   '$2a$12$T4lput4UbPcNAznwEBP4RejmQiddyOOh3AvDNzyyJZUR2C.sAe30.', 'SOPORTE')
ON CONFLICT (username) DO NOTHING;

-- Tabla de mensajes
CREATE TABLE IF NOT EXISTS messages (
    id         BIGSERIAL    PRIMARY KEY,
    user_id    BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    username   VARCHAR(100) NOT NULL,
    text       TEXT         NOT NULL CHECK (length(text) > 0 AND length(text) <= 2000),
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_user_id    ON messages(user_id);
