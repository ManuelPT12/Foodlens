# schemas/user_favorite_meal_types_schema.py

from pydantic import BaseModel
from typing import Optional

class UserFavoriteMealTypeBase(BaseModel):
    user_id: int
    meal_type_id: int

class UserFavoriteMealTypeCreate(UserFavoriteMealTypeBase):
    """
    Usado en POST /user-favorite-meal-types para asociar un tipo de comida favorito a un usuario.
    """
    pass

class UserFavoriteMealTypeUpdate(BaseModel):
    """
    Usado en PUT /user-favorite-meal-types/{user_id}/{meal_type_id} para actualizar la asociación.
    Permite cambiar uno o ambos IDs.
    """
    user_id: Optional[int] = None
    meal_type_id: Optional[int] = None

    class Config:
        orm_mode = True

class UserFavoriteMealTypeOut(UserFavoriteMealTypeBase):
    """
    Respuesta para GET /user-favorite-meal-types y GET /user-favorite-meal-types/{user_id}/{meal_type_id}.
    """
    class Config:
        orm_mode = True
