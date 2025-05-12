# schemas/menus_schema.py

from pydantic import BaseModel, HttpUrl
from typing import Optional
from datetime import datetime

class MenuBase(BaseModel):
    restaurant_id: int
    name: str
    image_url: Optional[HttpUrl] = None

class MenuCreate(MenuBase):
    """
    Usado en POST /menus para crear un nuevo menú.
    Hereda restaurant_id y name obligatorios, image_url opcional.
    """
    pass

class MenuUpdate(BaseModel):
    """
    Usado en PUT /menus/{menu_id} para actualizar un menú.
    Todos los campos opcionales para actualizaciones parciales.
    """
    restaurant_id: Optional[int] = None
    name: Optional[str] = None
    image_url: Optional[HttpUrl] = None

    class Config:
        orm_mode = True

class MenuOut(MenuBase):
    """
    Respuesta para GET /menus y GET /menus/{menu_id}.
    Incluye el campo `id` y `last_updated`.
    """
    id: int
    last_updated: datetime

    class Config:
        orm_mode = True
