from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import Restaurants
from app.schemas.restaurants_schema import (
    RestaurantCreate,
    RestaurantOut,
    RestaurantUpdate,
)
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
    cached = redis_client.get("restaurants_cache")
    if cached:
        return json.loads(cached)
    items = db.query(Restaurants).all()
    data = [RestaurantOut.from_orm(r).dict() for r in items]
    redis_client.set("restaurants_cache", json.dumps(data), ex=60)
    return data

@router.get("/{restaurant_id}", response_model=RestaurantOut)
def get_restaurant(restaurant_id: int, db: Session = Depends(get_db)):
    item = db.query(Restaurants).get(restaurant_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    return item

@router.post("/", response_model=RestaurantOut, status_code=status.HTTP_201_CREATED)
def create_restaurant(rest: RestaurantCreate, db: Session = Depends(get_db)):
    db_obj = Restaurants(**rest.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("restaurants_cache")
    return db_obj

@router.put("/{restaurant_id}", response_model=RestaurantOut)
def update_restaurant(
    restaurant_id: int,
    upd: RestaurantUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(Restaurants).get(restaurant_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("restaurants_cache")
    return item

@router.delete("/{restaurant_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_restaurant(restaurant_id: int, db: Session = Depends(get_db)):
    item = db.query(Restaurants).get(restaurant_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    db.delete(item)
    db.commit()
    redis_client.delete("restaurants_cache")
    return
