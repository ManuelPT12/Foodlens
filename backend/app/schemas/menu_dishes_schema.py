# schemas/menu_dishes_schema.py

from pydantic import BaseModel
from typing import Optional

class MenuDishBase(BaseModel):
    restaurant_menu_id: int
    name: str
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

class MenuDishCreate(MenuDishBase):
    """
    Usado en POST /menu-dishes para crear un nuevo plato de menú.
    Hereda todos los campos obligatorios de MenuDishBase.
    """
    pass

class MenuDishUpdate(BaseModel):
    """
    Usado en PUT /menu-dishes/{dish_id} para actualizar un plato de menú.
    Todos los campos opcionales para permitir actualizaciones parciales.
    """
    restaurant_menu_id: Optional[int] = None
    name: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

    class Config:
        orm_mode = True

class MenuDishOut(MenuDishBase):
    """
    Respuesta para GET /menu-dishes y GET /menu-dishes/{dish_id}.
    Incluye el campo `id`.
    """
    id: int

    class Config:
        orm_mode = True
