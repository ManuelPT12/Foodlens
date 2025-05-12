from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import RestaurantTypeLinks
from app.schemas.restaurant_type_links_schema import (
    RestaurantTypeLinkCreate,
    RestaurantTypeLinkOut,
)
import json

router = APIRouter(prefix="/restaurant-type-links", tags=["Restaurant Type Links"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[RestaurantTypeLinkOut])
def get_all_restaurant_type_links(db: Session = Depends(get_db)):
    cached = redis_client.get("restaurant_type_links_cache")
    if cached:
        return json.loads(cached)
    items = db.query(RestaurantTypeLinks).all()
    data = [RestaurantTypeLinkOut.from_orm(i).dict() for i in items]
    redis_client.set("restaurant_type_links_cache", json.dumps(data), ex=60)
    return data

@router.get("/{restaurant_id}/{type_id}", response_model=RestaurantTypeLinkOut)
def get_restaurant_type_link(restaurant_id: int, type_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(RestaurantTypeLinks)
        .filter_by(restaurant_id=restaurant_id, type_id=type_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Link not found")
    return item

@router.post("/", response_model=RestaurantTypeLinkOut, status_code=status.HTTP_201_CREATED)
def create_restaurant_type_link(
    payload: RestaurantTypeLinkCreate,
    db: Session = Depends(get_db)
):
    db_obj = RestaurantTypeLinks(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("restaurant_type_links_cache")
    return db_obj

@router.delete("/{restaurant_id}/{type_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_restaurant_type_link(restaurant_id: int, type_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(RestaurantTypeLinks)
        .filter_by(restaurant_id=restaurant_id, type_id=type_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Link not found")
    db.delete(item)
    db.commit()
    redis_client.delete("restaurant_type_links_cache")
    return
