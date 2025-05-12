# schemas/user_diets_schema.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class UserDietBase(BaseModel):
    user_id: int
    daily_calories: int
    daily_protein: float
    daily_carbs: float
    daily_fat: float

class UserDietCreate(UserDietBase):
    """
    Usado en POST /user-diets para crear o actualizar la dieta de un usuario.
    """
    pass

class UserDietUpdate(BaseModel):
    """
    Usado en PUT /user-diets/{user_id} para actualizar valores de dieta.
    Todos los campos opcionales.
    """
    daily_calories: Optional[int] = None
    daily_protein: Optional[float] = None
    daily_carbs: Optional[float] = None
    daily_fat: Optional[float] = None

    class Config:
        orm_mode = True

class UserDietOut(UserDietBase):
    """
    Respuesta para GET /user-diets y GET /user-diets/{user_id}.
    Incluye `calculated_at`.
    """
    calculated_at: datetime

    class Config:
        orm_mode = True
