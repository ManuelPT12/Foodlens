from pydantic import BaseModel

class UserAllergenOut(BaseModel):
    user_id: int
    allergen_id: int

    class Config:
        orm_mode = True

class UserAllergenCreate(BaseModel):
    user_id: int
    allergen_id: int

    class Config:
        orm_mode = True
