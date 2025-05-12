# schemas/user_allergens_schema.py

from pydantic import BaseModel
from typing import Optional

class UserAllergenBase(BaseModel):
    user_id: int
    allergen_id: int

class UserAllergenCreate(UserAllergenBase):
    """
    Usado en POST /user-allergens para asociar un alérgeno a un usuario.
    Ambos campos obligatorios.
    """
    pass

class UserAllergenUpdate(BaseModel):
    """
    Usado en PUT /user-allergens/{user_id}/{allergen_id} para actualizar la asociación.
    Permite cambiar uno o ambos IDs.
    """
    user_id: Optional[int] = None
    allergen_id: Optional[int] = None

    class Config:
        orm_mode = True

class UserAllergenOut(UserAllergenBase):
    """
    Respuesta para GET /user-allergens y GET /user-allergens/{user_id}/{allergen_id}.
    """
    class Config:
        orm_mode = True
