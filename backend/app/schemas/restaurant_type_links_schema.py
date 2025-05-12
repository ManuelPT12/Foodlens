# schemas/restaurant_type_links_schema.py

from pydantic import BaseModel
from typing import Optional

class RestaurantTypeLinkBase(BaseModel):
    restaurant_id: int
    type_id: int

class RestaurantTypeLinkCreate(RestaurantTypeLinkBase):
    """
    Usado en POST /restaurant-type-links para asociar un tipo a un restaurante.
    """
    pass

class RestaurantTypeLinkUpdate(BaseModel):
    """
    Usado en PUT /restaurant-type-links/{restaurant_id}/{type_id} para actualizar la asociación.
    Todos los campos opcionales.
    """
    restaurant_id: Optional[int] = None
    type_id: Optional[int] = None

    class Config:
        orm_mode = True

class RestaurantTypeLinkOut(RestaurantTypeLinkBase):
    """
    Salida para GET /restaurant-type-links y GET /restaurant-type-links/{restaurant_id}/{type_id}.
    """
    class Config:
        orm_mode = True
