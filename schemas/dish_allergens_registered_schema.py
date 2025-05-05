from pydantic import BaseModel

class DishAllergenRegisteredOut(BaseModel):
    dish_id: int
    allergen_id: int

    class Config:
        orm_mode = True

class DishAllergenRegisteredCreate(BaseModel):
    dish_id: int
    allergen_id: int

    class Config:
        orm_mode = True