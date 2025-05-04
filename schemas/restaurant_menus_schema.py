from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class RestaurantMenuCreate(BaseModel):
    user_id: int
    restaurant_name: str
    location: Optional[str] = None
    image_url: Optional[str] = None

    class Config:
        orm_mode = True

class RestaurantMenuOut(BaseModel):
    id: int
    user_id: int
    restaurant_name: str
    location: Optional[str] = None
    image_url: Optional[str] = None
    scanned_at: datetime

    class Config:
        orm_mode = True