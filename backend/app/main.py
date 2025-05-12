from fastapi import FastAPI
from .models import models
from . import database
from .routes import (
    auth,
    chat,
    users,
    meal_log,
    allergens,
    dishes,
    menus,
    menu_dishes,
    restaurant_menus,
    restaurants,
    dish_allergens_registered,
    user_allergens,
    user_restaurant_ratings,
    meal_types,
    user_diets,
    user_favourite_meal_types,
    user_meal_plan,
    restaurant_type_links,
)

# Crea todas las tablas
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(
    title="Tu API Nutricional",
    version="1.0",
    description="Endpoints para usuarios, comidas, restaurantes y más"
)

# Routers de autenticación y chat
app.include_router(auth.router)
app.include_router(chat.router)

# Routers CRUD + caché
app.include_router(users.router)
app.include_router(meal_log.router)
app.include_router(allergens.router)
app.include_router(dishes.router)
app.include_router(menus.router)
app.include_router(menu_dishes.router)
app.include_router(restaurant_menus.router)
app.include_router(restaurants.router)
app.include_router(dish_allergens_registered.router)
app.include_router(user_allergens.router)
app.include_router(user_restaurant_ratings.router)
app.include_router(meal_types.router)
app.include_router(user_diets.router)
app.include_router(user_favourite_meal_types.router)
app.include_router(user_meal_plan.router)
app.include_router(restaurant_type_links.router)
