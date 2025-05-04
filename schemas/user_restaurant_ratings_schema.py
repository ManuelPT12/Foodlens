from pydantic import BaseModel
from typing import Optional

class UserRestaurantRatingCreate(BaseModel):
    user_id: int
    restaurant_id: int
    rating: Optional[int] = None
    review: Optional[str] = None

    class Config:
        orm_mode = True

class UserRestaurantRatingOut(BaseModel):
    user_id: int
    restaurant_id: int
    rating: Optional[int] = None
    review: Optional[str] = None
    rated_at: str

    class Config:
        orm_mode = True