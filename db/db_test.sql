-- Insertar usuarios
INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, edad, sexo, objetivo, tipo_alimentacion) VALUES
('Juan', 'Pérez', '1995-05-12', 29, 'M', 'ganar músculo', 'omnivoro'),
('María', 'Gómez', '1998-08-21', 26, 'F', 'perder grasa', 'vegetariano'),
('Carlos', 'Ruiz', '1990-02-15', 34, 'M', 'subir peso', 'flexitariano'),
('Lucía', 'Fernández', '2000-01-30', 24, 'F', 'rendimiento deportivo', 'pescetariano'),
('Andrés', 'Santos', '1987-11-05', 37, 'M', 'bajar peso', 'omnivoro'),
('Laura', 'Martínez', '1999-07-19', 25, 'F', 'mantener peso', 'vegano'),
('Sergio', 'Díaz', '1993-03-08', 31, 'M', 'mejorar salud digestiva', 'omnivoro'),
('Ana', 'Morales', '1996-12-12', 28, 'F', 'alimentación consciente', 'flexitariano');

-- Insertar alérgenos
INSERT INTO alergenos_usuario (id_usuario, alergeno) VALUES
(1, 'Gluten'),
(1, 'Lactosa'),
(1, 'Frutos secos'),
(4, 'Mariscos'),
(5, 'Ninguno'),
(6, 'Huevo'),
(7, 'Gluten'),
(7, 'Frutos secos');

-- Insertar preferencias de comida
INSERT INTO preferencias_usuario (id_usuario, tipo_cocina) VALUES
(1, 'Italiana'),
(1, 'Japonesa'),
(3, 'Mexicana'),
(3, 'India'),
(5, 'Mediterránea'),
(7, 'Vegetariana'),
(7, 'China'),
(8, 'Hamburguesas');
