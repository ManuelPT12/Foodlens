# app/schemas/user_schema.py

from pydantic import BaseModel, EmailStr
from datetime import date, datetime
from typing import Optional

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
    activity_level: Optional[str] = None
    is_diabetic: bool = False

class UserCreate(UserBase):
    """
    Usado en POST /users para crear un nuevo usuario.
    Incluye contraseña obligatoria.
    """
    password: str

class UserLogin(BaseModel):
    """
    Usado en POST /auth/login para autenticación.
    """
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    """
    Usado en PUT /users/{user_id} para actualizar perfil.
    Todos los campos opcionales.
    """
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    birth_date: Optional[date] = None
    weight: Optional[float] = None
    height: Optional[float] = None
    age: Optional[int] = None
    gender: Optional[str] = None
    goal: Optional[str] = None
    diet_type: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    activity_level: Optional[str] = None
    is_diabetic: Optional[bool] = None

    class Config:
        from_attributes = True

class UserOut(UserBase):
    """
    Salida para GET /users y GET /users/{user_id}.
    Incluye id y created_at, sin exponer la contraseña.
    """
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
