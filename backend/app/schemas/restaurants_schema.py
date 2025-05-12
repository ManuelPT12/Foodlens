# schemas/restaurants_schema.py

from pydantic import BaseModel, HttpUrl
from typing import Optional

class RestaurantBase(BaseModel):
    name: str
    address: Optional[str] = None
    phone: Optional[str] = None
    website: Optional[HttpUrl] = None

class RestaurantCreate(RestaurantBase):
    """
    Usado en POST /restaurants para crear un nuevo restaurante.
    """
    pass

class RestaurantUpdate(BaseModel):
    """
    Usado en PUT /restaurants/{restaurant_id} para actualizar un restaurante.
    Todos los campos opcionales para permitir actualizaciones parciales.
    """
    name: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    website: Optional[HttpUrl] = None

    class Config:
        orm_mode = True

class RestaurantOut(RestaurantBase):
    """
    Respuesta para GET /restaurants y GET /restaurants/{restaurant_id}.
    Incluye el campo `id`.
    """
    id: int

    class Config:
        orm_mode = True
