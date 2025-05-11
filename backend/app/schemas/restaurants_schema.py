from pydantic import BaseModel
from typing import Optional

class RestaurantCreate(BaseModel):
    name: str
    address: str = None
    phone: str = None
    website: str = None

    class Config:
        orm_mode = True

class RestaurantOut(BaseModel):
    id: int
    name: str
    address: str = None
    phone: str = None
    website: str = None

    class Config:
        orm_mode = True