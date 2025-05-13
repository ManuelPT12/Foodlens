# schemas/meal_log_schema.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class MealLogBase(BaseModel):
    user_id: int
    meal_date: datetime
    meal_type: str
    dish_name: str
    description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None

    class Config:
        from_attributes = True

class MealLogCreate(MealLogBase):
    """
    Usado en POST /meal-logs para crear un nuevo registro de comida.
    """
    pass

class MealLogUpdate(BaseModel):
    """
    Usado en PUT /meal-logs/{id} para actualizar un registro.
    Todos los campos opcionales.
    """
    user_id: Optional[int] = None
    meal_date: Optional[datetime] = None
    meal_type: Optional[str] = None
    dish_name: Optional[str] = None
    description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None

    class Config:
        from_attributes = True

class MealLogOut(MealLogBase):
    """
    Respuesta para GET /meal-logs y GET /meal-logs/{id}.
    Incluye `id` y `created_at`.
    """
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
