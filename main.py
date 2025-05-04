
from fastapi import FastAPI
from routers import users, allergens, dishes, menus, restaurants, user_allergens, meal_log, dish_allergens_registered, restaurant_menus, menu_dishes, user_restaurant_ratings

app = FastAPI(
    title="Food AI API",
    description="API para gestionar usuarios, comidas, alérgenos, restaurantes, etc.",
    version="1.0.0"
)

# Incluir los routers
app.include_router(users.router)
app.include_router(allergens.router)
app.include_router(dishes.router)
app.include_router(menus.router)
app.include_router(restaurants.router)
app.include_router(user_allergens.router)
app.include_router(meal_log.router)
app.include_router(dish_allergens_registered.router)
app.include_router(restaurant_menus.router)
app.include_router(menu_dishes.router)
app.include_router(user_restaurant_ratings.router)
