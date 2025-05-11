from pydantic import BaseModel
from typing import Optional

class AllergenCreate(BaseModel):
    name: str
    icon_url: str = None
    description: str = None

    class Config:
        orm_mode = True

class AllergenOut(BaseModel):
    id: int
    name: str
    icon_url: str = None
    description: str = None

    class Config:
        orm_mode = True