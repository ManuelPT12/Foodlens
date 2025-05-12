from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.models.models import User
from app.schemas.users_schema import UserCreate, UserOut, UserUpdate
from app.database import SessionLocal, redis_client
import json

router = APIRouter(prefix="/users", tags=["Users"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=UserOut, status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    # Invalida caché
    redis_client.delete("users_cache")
    return db_user

@router.get("/", response_model=list[UserOut])
def get_all_users(db: Session = Depends(get_db)):
    # Intenta caché
    cached = redis_client.get("users_cache")
    if cached:
        return json.loads(cached)
    users = db.query(User).all()
    users_data = [UserOut.from_orm(u).dict() for u in users]
    redis_client.set("users_cache", json.dumps(users_data), ex=60)
    return users_data

@router.get("/{user_id}", response_model=UserOut)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/{user_id}", response_model=UserOut)
def update_user(
    user_id: int,
    user_update: UserUpdate,
    db: Session = Depends(get_db)
):
    user = db.query(User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    for field, value in user_update:
        setattr(user, field, value)
    db.commit()
    db.refresh(user)
    # Invalida caché
    redis_client.delete("users_cache")
    return user

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    db.delete(user)
    db.commit()
    # Invalida caché
    redis_client.delete("users_cache")
    return
