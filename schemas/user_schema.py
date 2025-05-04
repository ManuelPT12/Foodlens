from pydantic import BaseModel, EmailStr
from datetime import date

class UserBase(BaseModel):
    first_name: str
    last_name: str
    birth_date: date
    age: int
    gender: str
    goal: str
    diet_type: str
    email: EmailStr

class UserCreate(UserBase):
    password_hash: str

class UserOut(UserBase):
    id: int
    created_at: str

    class Config:
        orm_mode = True
