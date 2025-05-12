# schemas/user_meal_plan_schema.py

from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime

class UserMealPlanBase(BaseModel):
    user_id: int
    plan_date: date
    meal_type: int
    dish_description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None

class UserMealPlanCreate(UserMealPlanBase):
    """
    Usado en POST /user-meal-plans para crear un nuevo plan de comida.
    """
    pass

class UserMealPlanUpdate(BaseModel):
    """
    Usado en PUT /user-meal-plans/{plan_id} para actualizar un plan.
    Todos los campos opcionales.
    """
    user_id: Optional[int] = None
    plan_date: Optional[date] = None
    meal_type: Optional[int] = None
    dish_description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None

    class Config:
        orm_mode = True

class UserMealPlanOut(UserMealPlanBase):
    """
    Respuesta para GET /user-meal-plans y GET /user-meal-plans/{plan_id}.
    Incluye `id` y `created_at`.
    """
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
