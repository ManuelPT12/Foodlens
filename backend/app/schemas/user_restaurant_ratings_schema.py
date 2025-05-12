# schemas/user_restaurant_ratings_schema.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class UserRestaurantRatingBase(BaseModel):
    user_id: int
    restaurant_id: int
    rating: Optional[float] = None
    review: Optional[str] = None

class UserRestaurantRatingCreate(UserRestaurantRatingBase):
    """
    Usado en POST /user-restaurant-ratings para crear una valoración.
    """
    pass

class UserRestaurantRatingUpdate(BaseModel):
    """
    Usado en PUT /user-restaurant-ratings/{user_id}/{restaurant_id} para actualizar rating o review.
    """
    rating: Optional[float] = None
    review: Optional[str] = None

    class Config:
        orm_mode = True

class UserRestaurantRatingOut(UserRestaurantRatingBase):
    """
    Respuesta para GET /user-restaurant-ratings y GET /user-restaurant-ratings/{user_id}/{restaurant_id}.
    Incluye la fecha `rated_at`.
    """
    rated_at: datetime

    class Config:
        orm_mode = True
