from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import UserFavoriteMealTypes
from app.schemas.user_favourite_meal_types_schema import (
    UserFavoriteMealTypeCreate,
    UserFavoriteMealTypeOut,
)
import json

router = APIRouter(prefix="/user-favorite-meal-types", tags=["User Favorite Meal Types"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[UserFavoriteMealTypeOut])
def get_all_favorites(db: Session = Depends(get_db)):
    cached = redis_client.get("user_favorite_meal_types_cache")
    if cached:
        return json.loads(cached)
    items = db.query(UserFavoriteMealTypes).all()
    data = [UserFavoriteMealTypeOut.from_orm(i).dict() for i in items]
    redis_client.set("user_favorite_meal_types_cache", json.dumps(data), ex=60)
    return data

@router.get("/{user_id}/{meal_type_id}", response_model=UserFavoriteMealTypeOut)
def get_favorite(user_id: int, meal_type_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserFavoriteMealTypes)
        .filter_by(user_id=user_id, meal_type_id=meal_type_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Favorite not found")
    return item

@router.post("/", response_model=UserFavoriteMealTypeOut, status_code=status.HTTP_201_CREATED)
def create_favorite(
    payload: UserFavoriteMealTypeCreate,
    db: Session = Depends(get_db)
):
    db_obj = UserFavoriteMealTypes(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("user_favorite_meal_types_cache")
    return db_obj

@router.delete("/{user_id}/{meal_type_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_favorite(user_id: int, meal_type_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserFavoriteMealTypes)
        .filter_by(user_id=user_id, meal_type_id=meal_type_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Favorite not found")
    db.delete(item)
    db.commit()
    redis_client.delete("user_favorite_meal_types_cache")
    return
