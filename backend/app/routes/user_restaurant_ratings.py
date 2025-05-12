from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import UserRestaurantRatings
from app.schemas.user_restaurant_ratings_schema import (
    UserRestaurantRatingCreate,
    UserRestaurantRatingOut,
    UserRestaurantRatingUpdate,
)
import json

router = APIRouter(prefix="/user-restaurant-ratings", tags=["User Restaurant Ratings"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[UserRestaurantRatingOut])
def get_all_user_restaurant_ratings(db: Session = Depends(get_db)):
    cached = redis_client.get("user_restaurant_ratings_cache")
    if cached:
        return json.loads(cached)
    items = db.query(UserRestaurantRatings).all()
    data = [UserRestaurantRatingOut.from_orm(i).dict() for i in items]
    redis_client.set("user_restaurant_ratings_cache", json.dumps(data), ex=60)
    return data

@router.get("/{user_id}/{restaurant_id}", response_model=UserRestaurantRatingOut)
def get_user_restaurant_rating(user_id: int, restaurant_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserRestaurantRatings)
        .filter_by(user_id=user_id, restaurant_id=restaurant_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Rating not found")
    return item

@router.post("/", response_model=UserRestaurantRatingOut, status_code=status.HTTP_201_CREATED)
def create_user_restaurant_rating(
    payload: UserRestaurantRatingCreate,
    db: Session = Depends(get_db)
):
    db_obj = UserRestaurantRatings(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("user_restaurant_ratings_cache")
    return db_obj

@router.put("/{user_id}/{restaurant_id}", response_model=UserRestaurantRatingOut)
def update_user_restaurant_rating(
    user_id: int,
    restaurant_id: int,
    upd: UserRestaurantRatingUpdate,
    db: Session = Depends(get_db)
):
    item = (
        db.query(UserRestaurantRatings)
        .filter_by(user_id=user_id, restaurant_id=restaurant_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Rating not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("user_restaurant_ratings_cache")
    return item

@router.delete("/{user_id}/{restaurant_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_restaurant_rating(user_id: int, restaurant_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserRestaurantRatings)
        .filter_by(user_id=user_id, restaurant_id=restaurant_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Rating not found")
    db.delete(item)
    db.commit()
    redis_client.delete("user_restaurant_ratings_cache")
    return
