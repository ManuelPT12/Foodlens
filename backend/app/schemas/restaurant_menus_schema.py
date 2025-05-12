# schemas/restaurant_menus_schema.py

from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class RestaurantMenuBase(BaseModel):
    user_id: int
    restaurant_name: str
    location: Optional[str] = None
    image_url: Optional[str] = None

class RestaurantMenuCreate(RestaurantMenuBase):
    """
    Usado en POST /restaurant-menus para crear un nuevo menú de restaurante.
    Hereda todos los campos obligatorios de RestaurantMenuBase.
    """
    pass

class RestaurantMenuUpdate(BaseModel):
    """
    Usado en PUT /restaurant-menus/{menu_id} para actualizar un menú.
    Todos los campos opcionales para permitir actualizaciones parciales.
    """
    user_id: Optional[int] = None
    restaurant_name: Optional[str] = None
    location: Optional[str] = None
    image_url: Optional[str] = None

    class Config:
        orm_mode = True

class RestaurantMenuOut(RestaurantMenuBase):
    """
    Respuesta para GET /restaurant-menus y GET /restaurant-menus/{menu_id}.
    Incluye el campo `id` y `scanned_at`.
    """
    id: int
    scanned_at: datetime

    class Config:
        orm_mode = True
