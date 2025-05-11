from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import Restaurants
from schemas.restaurants_schema import RestaurantOut, RestaurantCreate
from app.database import redis_client
import json

router = APIRouter(prefix="/restaurants", tags=["Restaurants"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[RestaurantOut])
def get_all_restaurants(db: Session = Depends(get_db)):
    cached_restaurants = redis_client.get("restaurants_cache")
    if cached_restaurants:
        return json.loads(cached_restaurants)
    restaurants = db.query(Restaurants).all()
    restaurants_data = [RestaurantOut.from_orm(restaurant).dict() for restaurant in restaurants]
    redis_client.set("restaurants_cache", json.dumps(restaurants_data), ex=60)
    return restaurants_data

@router.post("/restaurants")
def create_restaurant(rest: RestaurantCreate, db: Session = Depends(get_db)):
    db_rest = Restaurants(**rest.dict())
    db.add(db_rest)
    db.commit()
    db.refresh(db_rest)
    return db_rest