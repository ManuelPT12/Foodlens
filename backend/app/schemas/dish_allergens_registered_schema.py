# schemas/dish_allergens_registered_schema.py

from pydantic import BaseModel
from typing import Optional

class DishAllergenBase(BaseModel):
    dish_id: int
    allergen_id: int

    class Config:
        orm_mode = True

class DishAllergenRegisteredCreate(DishAllergenBase):
    """
    Usado en POST /dish-allergens:
    Ambos campos obligatorios para crear la asociación.
    """
    pass

class DishAllergenRegisteredUpdate(BaseModel):
    """
    Usado en PUT /dish-allergens/{dish_id}/{allergen_id}:
    Permite cambiar uno o ambos IDs de la asociación.
    """
    dish_id: Optional[int] = None
    allergen_id: Optional[int] = None

    class Config:
        orm_mode = True

class DishAllergenRegisteredOut(DishAllergenBase):
    """
    Salida para GET /dish-allergens y GET /dish-allergens/{dish_id}/{allergen_id}.
    """
    pass
