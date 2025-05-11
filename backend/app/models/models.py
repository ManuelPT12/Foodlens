
from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text, DECIMAL, TIMESTAMP
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    birth_date = Column(Date, nullable=False)
    weight = Column(DECIMAL(5, 1), nullable=False)
    height = Column(DECIMAL(5, 1), nullable=False)
    age = Column(Integer, nullable=False)
    gender = Column(String(20), nullable=False)
    goal = Column(String(100), nullable=False)
    diet_type = Column(String(100), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    password = Column(Text, nullable=False)
    created_at = Column(TIMESTAMP, server_default=func.now())

class Allergens(Base):
    __tablename__ = "allergens"
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    icon_url = Column(Text)
    description = Column(Text)

class UserAllergens(Base):
    __tablename__ = "user_allergens"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    allergen_id = Column(Integer, ForeignKey("allergens.id", ondelete="CASCADE"), primary_key=True)

class MealLog(Base):
    __tablename__ = "meal_log"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    meal_date = Column(Date, nullable=False)
    meal_type = Column(String(50))
    dish_name = Column(String(255))
    description = Column(Text)
    calories = Column(Integer)
    protein = Column(DECIMAL(6,2))
    carbs = Column(DECIMAL(6,2))
    fat = Column(DECIMAL(6,2))
    image_url = Column(Text)
    created_at = Column(TIMESTAMP, server_default=func.now())

class Restaurants(Base):
    __tablename__ = "restaurants"
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    address = Column(Text)
    phone = Column(String(20))
    website = Column(Text)

class Menus(Base):
    __tablename__ = "menus"
    id = Column(Integer, primary_key=True)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    image_url = Column(Text)
    last_updated = Column(TIMESTAMP, server_default=func.now())

class Dishes(Base):
    __tablename__ = "dishes"
    id = Column(Integer, primary_key=True)
    menu_id = Column(Integer, ForeignKey("menus.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    description = Column(Text)
    price = Column(DECIMAL(10,2))
    calories = Column(Integer)
    protein = Column(DECIMAL(6,2))
    carbs = Column(DECIMAL(6,2))
    fat = Column(DECIMAL(6,2))

class DishAllergensRegistered(Base):
    __tablename__ = "dish_allergens_registered"
    dish_id = Column(Integer, ForeignKey("dishes.id", ondelete="CASCADE"), primary_key=True)
    allergen_id = Column(Integer, ForeignKey("allergens.id", ondelete="CASCADE"), primary_key=True)

class RestaurantMenus(Base):
    __tablename__ = "restaurant_menus"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    restaurant_name = Column(String(255))
    location = Column(Text)
    image_url = Column(Text)
    scanned_at = Column(TIMESTAMP, server_default=func.now())

class MenuDishes(Base):
    __tablename__ = "menu_dishes"
    id = Column(Integer, primary_key=True)
    restaurant_menu_id = Column(Integer, ForeignKey("restaurant_menus.id", ondelete="CASCADE"))
    name = Column(String(255))
    description = Column(Text)
    price = Column(DECIMAL(10,2))
    calories = Column(Integer)
    protein = Column(DECIMAL(6,2))
    carbs = Column(DECIMAL(6,2))
    fat = Column(DECIMAL(6,2))

class UserRestaurantRatings(Base):
    __tablename__ = "user_restaurant_ratings"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id", ondelete="CASCADE"), primary_key=True)
    rating = Column(Integer)
    review = Column(Text)
    rated_at = Column(TIMESTAMP, server_default=func.now())
