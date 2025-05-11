from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class MealLogCreate(BaseModel):
    user_id: int
    meal_date: datetime
    meal_type: str
    dish_name: str
    description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None

    class Config:
        orm_mode = True

class MealLogOut(BaseModel):
    id: int
    user_id: int
    meal_date: datetime
    meal_type: str
    dish_name: str
    description: Optional[str] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None
    image_url: Optional[str] = None
    created_at: str

    class Config:
        orm_mode = True