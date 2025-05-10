from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class MenuCreate(BaseModel):
    restaurant_id: int
    name: str
    image_url: str = None

    class Config:
        orm_mode = True

class MenuOut(BaseModel):
    id: int
    restaurant_id: int
    name: str
    image_url: str = None
    last_updated: datetime

    class Config:
        orm_mode = True