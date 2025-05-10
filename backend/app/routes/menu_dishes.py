from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import MenuDishes
from schemas.menu_dishes_schema import MenuDishOut, MenuDishCreate
from app.database import redis_client
import json

router = APIRouter(prefix="/menu-dishes", tags=["Menu Dishes"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[MenuDishOut])
def get_all_menu_dishes(db: Session = Depends(get_db)):
    cached_menu_dishes = redis_client.get("menu_dishes_cache")
    if cached_menu_dishes:
        return json.loads(cached_menu_dishes)
    menu_dishes = db.query(MenuDishes).all()
    menu_dishes_data = [MenuDishOut.from_orm(menu_dish).dict() for menu_dish in menu_dishes]
    redis_client.set("menu_dishes_cache", json.dumps(menu_dishes_data), ex=60)
    return menu_dishes_data

@router.post("/menu_dishes")
def create_menu_dish(dish: MenuDishCreate, db: Session = Depends(get_db)):
    db_dish = MenuDishes(**dish.dict())
    db.add(db_dish)
    db.commit()
    db.refresh(db_dish)
    return db_dish