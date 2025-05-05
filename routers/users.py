from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import User
from schemas.user_schema import UserCreate, UserOut
from redis_client import redis_client
import json

router = APIRouter(prefix="/users", tags=["Users"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=UserOut)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    redis_client.delete("users_cache")  # Limpiar la caché
    return db_user

@router.get("/", response_model=list[UserOut])
def get_all_users(db: Session = Depends(get_db)):
    cached_users = redis_client.get("users_cache")
    if cached_users:
        return json.loads(cached_users)
    users = db.query(User).all()
    users_data = [UserOut.from_orm(user).dict() for user in users]
    redis_client.set("users_cache", json.dumps(users_data), ex=60)  # TTL de 60 segundos
    return users_data