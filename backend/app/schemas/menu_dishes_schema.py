from pydantic import BaseModel
from typing import Optional

class MenuDishCreate(BaseModel):
    restaurant_menu_id: int
    name: str
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

    class Config:
        orm_mode = True

class MenuDishOut(BaseModel):
    id: int
    restaurant_menu_id: int
    name: str
    description: Optional[str] = None
    price: Optional[float] = None
    calories: Optional[int] = None
    protein: Optional[float] = None
    carbs: Optional[float] = None
    fat: Optional[float] = None

    class Config:
        orm_mode = True