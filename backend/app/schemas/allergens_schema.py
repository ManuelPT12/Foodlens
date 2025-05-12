# schemas/allergens_schema.py

from pydantic import BaseModel, HttpUrl
from typing import Optional

class AllergenBase(BaseModel):
    name: str
    icon_url: Optional[HttpUrl] = None
    description: Optional[str] = None

class AllergenCreate(AllergenBase):
    """Usado en POST /allergens"""
    pass

class AllergenUpdate(BaseModel):
    """Todos los campos opcionales para PATCH/PUT"""
    name: Optional[str] = None
    icon_url: Optional[HttpUrl] = None
    description: Optional[str] = None

    class Config:
        orm_mode = True

class AllergenOut(AllergenBase):
    id: int

    class Config:
        orm_mode = True
