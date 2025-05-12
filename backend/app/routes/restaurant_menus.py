from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import RestaurantMenus
from app.schemas.restaurant_menus_schema import (
    RestaurantMenuCreate,
    RestaurantMenuOut,
    RestaurantMenuUpdate,
)
import json

router = APIRouter(prefix="/restaurant-menus", tags=["Restaurant Menus"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[RestaurantMenuOut])
def get_all_restaurant_menus(db: Session = Depends(get_db)):
    cached = redis_client.get("restaurant_menus_cache")
    if cached:
        return json.loads(cached)
    items = db.query(RestaurantMenus).all()
    data = [RestaurantMenuOut.from_orm(i).dict() for i in items]
    redis_client.set("restaurant_menus_cache", json.dumps(data), ex=60)
    return data

@router.get("/{menu_id}", response_model=RestaurantMenuOut)
def get_restaurant_menu(menu_id: int, db: Session = Depends(get_db)):
    item = db.query(RestaurantMenus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant menu not found")
    return item

@router.post("/", response_model=RestaurantMenuOut, status_code=status.HTTP_201_CREATED)
def create_restaurant_menu(
    menu: RestaurantMenuCreate, db: Session = Depends(get_db)
):
    db_obj = RestaurantMenus(**menu.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("restaurant_menus_cache")
    return db_obj

@router.put("/{menu_id}", response_model=RestaurantMenuOut)
def update_restaurant_menu(
    menu_id: int,
    upd: RestaurantMenuUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(RestaurantMenus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant menu not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("restaurant_menus_cache")
    return item

@router.delete("/{menu_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_restaurant_menu(menu_id: int, db: Session = Depends(get_db)):
    item = db.query(RestaurantMenus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Restaurant menu not found")
    db.delete(item)
    db.commit()
    redis_client.delete("restaurant_menus_cache")
    return
