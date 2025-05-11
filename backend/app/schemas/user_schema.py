# app/schemas/user_schema.py
from pydantic import BaseModel, EmailStr
from datetime import date, datetime

class UserBase(BaseModel):
    first_name: str
    last_name: str
    birth_date: date
    weight: float
    height: float
    age: int
    gender: str
    goal: str
    diet_type: str
    email: EmailStr

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserOut(UserBase):
    id: int
    created_at: datetime 

    class Config:
        from_attributes = True  # <- En lugar de orm_mode en Pydantic v2
