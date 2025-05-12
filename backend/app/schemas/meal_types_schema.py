# schemas/meal_types_schema.py

from pydantic import BaseModel
from typing import Optional

class MealTypeBase(BaseModel):
    name: str

class MealTypeCreate(MealTypeBase):
    """
    Usado en POST /meal-types para crear un nuevo tipo de comida.
    """
    pass

class MealTypeUpdate(BaseModel):
    """
    Usado en PUT /meal-types/{meal_type_id} para actualizar un tipo de comida.
    Todos los campos opcionales.
    """
    name: Optional[str] = None

    class Config:
        orm_mode = True

class MealTypeOut(MealTypeBase):
    """
    Respuesta para GET /meal-types y GET /meal-types/{meal_type_id}.
    Incluye el campo `id`.
    """
    id: int

    class Config:
        orm_mode = True
