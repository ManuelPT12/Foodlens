-- Tabla principal de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20) NOT NULL CHECK (gender IN ('M', 'F', 'O')),
    goal VARCHAR(100) NOT NULL,
    diet_type VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de alérgenos disponibles (maestra)
CREATE TABLE allergens (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon_url TEXT,
    description TEXT
);

-- Tabla de alérgenos que tiene cada usuario (relación M:N)
CREATE TABLE user_allergens (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    allergen_id INT REFERENCES allergens(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, allergen_id)
);

-- Registro de comidas: manual o por foto
CREATE TABLE meal_log (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    meal_date DATE NOT NULL,
    meal_type VARCHAR(50), -- desayuno, comida, cena, etc.
    dish_name VARCHAR(255),
    description TEXT,
    calories INT,
    protein DECIMAL(6,2),
    carbs DECIMAL(6,2),
    fat DECIMAL(6,2),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Restaurantes (base estructurada, no los escaneados por usuario)
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    website TEXT
);

-- Menús oficiales de restaurantes (incluye imagen)
CREATE TABLE menus (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    image_url TEXT,
    last_updated TIMESTAMP DEFAULT NOW()
);

-- Platos dentro de los menús
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    menu_id INT REFERENCES menus(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    calories INT,
    protein DECIMAL(6,2),
    carbs DECIMAL(6,2),
    fat DECIMAL(6,2)
);

-- Relación M:N entre platos y alérgenos
CREATE TABLE dish_allergens_registered (
    dish_id INT REFERENCES dishes(id) ON DELETE CASCADE,
    allergen_id INT REFERENCES allergens(id) ON DELETE CASCADE,
    PRIMARY KEY (dish_id, allergen_id)
);

-- Menús escaneados por usuarios
CREATE TABLE restaurant_menus (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    restaurant_name VARCHAR(255),
    location TEXT,
    image_url TEXT,
    scanned_at TIMESTAMP DEFAULT NOW()
);

-- Platos detectados por la IA desde imágenes de menús escaneados
CREATE TABLE menu_dishes (
    id SERIAL PRIMARY KEY,
    restaurant_menu_id INT REFERENCES restaurant_menus(id) ON DELETE CASCADE,
    name VARCHAR(255),
    description TEXT,
    price DECIMAL(10,2),
    calories INT,
    protein DECIMAL(6,2),
    carbs DECIMAL(6,2),
    fat DECIMAL(6,2)
);

-- Valoraciones de usuarios a restaurantes
CREATE TABLE user_restaurant_ratings (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    restaurant_id INT REFERENCES restaurants(id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    rated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, restaurant_id)
);
