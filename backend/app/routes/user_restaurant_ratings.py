from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import UserRestaurantRatings
from schemas.user_restaurant_ratings_schema import UserRestaurantRatingOut, UserRestaurantRatingCreate
from app.database import redis_client
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
    cached_user_restaurant_ratings = redis_client.get("user_restaurant_ratings_cache")
    if cached_user_restaurant_ratings:
        return json.loads(cached_user_restaurant_ratings)
    user_restaurant_ratings = db.query(UserRestaurantRatings).all()
    user_restaurant_ratings_data = [UserRestaurantRatingOut.from_orm(user_restaurant_rating).dict() for user_restaurant_rating in user_restaurant_ratings]
    redis_client.set("user_restaurant_ratings_cache", json.dumps(user_restaurant_ratings_data), ex=60)
    return user_restaurant_ratings_data

@router.post("/user_restaurant_ratings")
def create_rating(rating: UserRestaurantRatingCreate, db: Session = Depends(get_db)):
    db_rating = UserRestaurantRatings(**rating.dict())
    db.add(db_rating)
    db.commit()
    return db_rating