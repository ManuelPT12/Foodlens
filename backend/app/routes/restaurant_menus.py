from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import RestaurantMenus
from schemas.restaurant_menus_schema import RestaurantMenuOut, RestaurantMenuCreate
from app.database import redis_client
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
    cached_restaurant_menus = redis_client.get("restaurant_menus_cache")
    if cached_restaurant_menus:
        return json.loads(cached_restaurant_menus)
    restaurant_menus = db.query(RestaurantMenus).all()
    restaurant_menus_data = [RestaurantMenuOut.from_orm(restaurant_menu).dict() for restaurant_menu in restaurant_menus]
    redis_client.set("restaurant_menus_cache", json.dumps(restaurant_menus_data), ex=60)
    return restaurant_menus_data

@router.post("/restaurant_menus")
def create_restaurant_menu(menu: RestaurantMenuCreate, db: Session = Depends(get_db)):
    db_menu = RestaurantMenus(**menu.dict())
    db.add(db_menu)
    db.commit()
    db.refresh(db_menu)
    return db_menu