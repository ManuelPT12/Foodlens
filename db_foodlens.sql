CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad INT NOT NULL,
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F', 'O')), --O es Otros
    objetivo VARCHAR(50) NOT NULL CHECK (objetivo IN (
  'subir peso', 'bajar peso', 'ganar músculo', 'perder grasa',
  'mantener peso', 'mejorar salud digestiva', 'controlar azúcar',
  'reducir colesterol', 'rendimiento deportivo', 'alimentación consciente'
)),
    tipo_alimentacion VARCHAR(50) NOT NULL CHECK (tipo_alimentacion IN ('vegetariano', 'vegano', 'omnivoro', 'flexitariano','pescetariano'))
);

-- Alergenos del usuario, pueden ser muchos.
CREATE TABLE IF NOT EXISTS alergenos_usuario (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    alergeno VARCHAR(100) NOT NULL DEFAULT 'ninguno'
);

-- Preferencias de comida del usuario, pueden ser muchas
CREATE TABLE IF NOT EXISTS preferencias_usuario (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo_cocina VARCHAR(100) NOT NULL DEFAULT 'ninguno'
);

CREATE TABLE IF NOT EXISTS menus_escaneados (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    texto_menu TEXT NOT NULL, -- Resultado OCR completo del menú
    platos_recomendados TEXT[], -- Lista de platos sugeridos por la IA
    tipo_entrada VARCHAR(20) DEFAULT 'menu' CHECK (tipo_entrada IN ('menu', 'plato'))
);

CREATE TABLE IF NOT EXISTS platos_consumidos (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    id_menu INT REFERENCES menus_escaneados(id) ON DELETE SET NULL,
    nombre_plato VARCHAR(255) NOT NULL,
    info_nutricional JSONB, -- Se guarda en json, la IA : {"kcal": 520, "proteinas": 25, "grasas": 15}
    foto_url TEXT, -- URL de la foto del plato si se ha hechado
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS platos_foto_casa (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre_detectado VARCHAR(255) NOT NULL,
    info_nutricional JSONB, -- Igual que antes
    foto_url TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
