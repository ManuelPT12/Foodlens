# schemas/dishes_schema.py

from pydantic import BaseModel
from typing import Optional

class DishBase(BaseModel):
    menu_id: int
    name: str
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

class DishCreate(DishBase):
    """
    Usado en POST /dishes para crear un nuevo plato.
    Todos los campos de DishBase, con name y menu_id obligatorios.
    """
    pass

class DishUpdate(BaseModel):
    """
    Usado en PUT /dishes/{dish_id} para actualizar un plato.
    Todos los campos opcionales.
    """
    menu_id: Optional[int] = None
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

    class Config:
        orm_mode = True

class DishOut(DishBase):
    """
    Respuesta en GET /dishes y GET /dishes/{dish_id}.
    Incluye el campo `id`.
    """
    id: int

    class Config:
        orm_mode = True
