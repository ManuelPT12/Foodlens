from sqlalchemy import Column, Integer, String, Date, Boolean, ForeignKey, Text, DECIMAL, TIMESTAMP
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
    activity_level = Column(String(50), nullable=True)
    is_diabetic = Column(Boolean, default=False)

    # Relationships
    meal_logs = relationship("MealLog", back_populates="user", cascade="all, delete-orphan")
    user_allergens = relationship("UserAllergens", back_populates="user", cascade="all, delete-orphan")
    user_diets = relationship("UserDiets", back_populates="user", uselist=False, cascade="all, delete-orphan")
    favorite_meal_types = relationship("UserFavoriteMealTypes", back_populates="user", cascade="all, delete-orphan")
    meal_plans = relationship("UserMealPlan", back_populates="user", cascade="all, delete-orphan")
    restaurant_menus = relationship("RestaurantMenus", back_populates="user", cascade="all, delete-orphan")
    restaurant_ratings = relationship("UserRestaurantRatings", back_populates="user", cascade="all, delete-orphan")

class Allergens(Base):
    __tablename__ = "allergens"
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    icon_url = Column(Text)
    description = Column(Text)

    user_links = relationship("UserAllergens", back_populates="allergen", cascade="all, delete-orphan")
    dish_allergens = relationship("DishAllergensRegistered", back_populates="allergen", cascade="all, delete-orphan")

class UserAllergens(Base):
    __tablename__ = "user_allergens"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    allergen_id = Column(Integer, ForeignKey("allergens.id", ondelete="CASCADE"), primary_key=True)

    user = relationship("User", back_populates="user_allergens")
    allergen = relationship("Allergens", back_populates="user_links")

class MealTypes(Base):
    __tablename__ = "meal_types"
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

    favorite_meal_by_user = relationship("UserFavoriteMealTypes", back_populates="meal_type", cascade="all, delete-orphan")
    restaurant_types = relationship("RestaurantTypeLinks", back_populates="type", cascade="all, delete-orphan")

class MealLog(Base):
    __tablename__ = "meal_log"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    meal_date = Column(Date, nullable=False)
    meal_type = Column(String(55))
    dish_name = Column(String(255))
    description = Column(Text)
    calories = Column(Integer)
    protein = Column(DECIMAL(6, 2))
    carbs = Column(DECIMAL(6, 2))
    fat = Column(DECIMAL(6, 2))
    image_url = Column(Text)
    created_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="meal_logs")

class UserDiets(Base):
    __tablename__ = "user_diets"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    daily_calories = Column(Integer)
    daily_protein = Column(DECIMAL(8, 2))
    daily_carbs = Column(DECIMAL(8, 2))
    daily_fat = Column(DECIMAL(8, 2))
    calculated_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="user_diets")

class UserFavoriteMealTypes(Base):
    __tablename__ = "user_favorite_meal_types"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    meal_type_id = Column(Integer, ForeignKey("meal_types.id", ondelete="CASCADE"), primary_key=True)

    user = relationship("User", back_populates="favorite_meal_types")
    meal_type = relationship("MealTypes", back_populates="favorite_meal_by_user")

class Restaurants(Base):
    __tablename__ = "restaurants"
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    address = Column(Text)
    phone = Column(String(20))
    website = Column(Text)

    menus = relationship("Menus", back_populates="restaurant", cascade="all, delete-orphan")
    ratings = relationship("UserRestaurantRatings", back_populates="restaurant", cascade="all, delete-orphan")
    type_links = relationship("RestaurantTypeLinks", back_populates="restaurant", cascade="all, delete-orphan")

class RestaurantMenus(Base):
    __tablename__ = "restaurant_menus"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    restaurant_name = Column(String(255))
    location = Column(Text)
    image_url = Column(Text)
    scanned_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="restaurant_menus")
    menu_dishes = relationship("MenuDishes", back_populates="restaurant_menu", cascade="all, delete-orphan")

class RestaurantTypeLinks(Base):
    __tablename__ = "restaurant_type_links"
    restaurant_id = Column(Integer, ForeignKey("restaurants.id", ondelete="CASCADE"), primary_key=True)
    type_id = Column(Integer, ForeignKey("meal_types.id", ondelete="CASCADE"), primary_key=True)

    restaurant = relationship("Restaurants", back_populates="type_links")
    type = relationship("MealTypes", back_populates="restaurant_types")

class Menus(Base):
    __tablename__ = "menus"
    id = Column(Integer, primary_key=True)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    image_url = Column(Text)
    last_updated = Column(TIMESTAMP, server_default=func.now())

    restaurant = relationship("Restaurants", back_populates="menus")
    dishes = relationship("Dishes", back_populates="menu", cascade="all, delete-orphan")

class Dishes(Base):
    __tablename__ = "dishes"
    id = Column(Integer, primary_key=True)
    menu_id = Column(Integer, ForeignKey("menus.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    description = Column(Text)
    price = Column(DECIMAL(10, 2))
    calories = Column(Integer)
    protein = Column(DECIMAL(6, 2))
    carbs = Column(DECIMAL(6, 2))
    fat = Column(DECIMAL(6, 2))

    menu = relationship("Menus", back_populates="dishes")
    allergens = relationship("DishAllergensRegistered", back_populates="dish", cascade="all, delete-orphan")

class DishAllergensRegistered(Base):
    __tablename__ = "dish_allergens_registered"
    dish_id = Column(Integer, ForeignKey("dishes.id", ondelete="CASCADE"), primary_key=True)
    allergen_id = Column(Integer, ForeignKey("allergens.id", ondelete="CASCADE"), primary_key=True)

    dish = relationship("Dishes", back_populates="allergens")
    allergen = relationship("Allergens", back_populates="dish_allergens")

class MenuDishes(Base):
    __tablename__ = "menu_dishes"
    id = Column(Integer, primary_key=True)
    restaurant_menu_id = Column(Integer, ForeignKey("restaurant_menus.id", ondelete="CASCADE"))
    name = Column(String(255))
    description = Column(Text)
    price = Column(DECIMAL(10, 2))
    calories = Column(Integer)
    protein = Column(DECIMAL(6, 2))
    carbs = Column(DECIMAL(6, 2))
    fat = Column(DECIMAL(6, 2))

    restaurant_menu = relationship("RestaurantMenus", back_populates="menu_dishes")

class UserMealPlan(Base):
    __tablename__ = "user_meal_plan"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    plan_date = Column(Date, nullable=False)
    meal_type = Column(String(55))
    dish_description = Column(Text)
    calories = Column(Integer)
    protein = Column(DECIMAL(6, 2))
    carbs = Column(DECIMAL(6, 2))
    fat = Column(DECIMAL(6, 2))
    image_url = Column(Text)
    created_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="meal_plans")

class UserRestaurantRatings(Base):
    __tablename__ = "user_restaurant_ratings"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id", ondelete="CASCADE"), primary_key=True)
    rating = Column(DECIMAL(2, 1))
    review = Column(Text)
    rated_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="restaurant_ratings")
    restaurant = relationship("Restaurants", back_populates="ratings")
