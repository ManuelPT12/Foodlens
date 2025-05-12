from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import MenuDishes
from app.schemas.menu_dishes_schema import MenuDishCreate, MenuDishOut, MenuDishUpdate
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
    cached = redis_client.get("menu_dishes_cache")
    if cached:
        return json.loads(cached)
    items = db.query(MenuDishes).all()
    data = [MenuDishOut.from_orm(i).dict() for i in items]
    redis_client.set("menu_dishes_cache", json.dumps(data), ex=60)
    return data

@router.get("/{dish_id}", response_model=MenuDishOut)
def get_menu_dish(dish_id: int, db: Session = Depends(get_db)):
    item = db.query(MenuDishes).get(dish_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu dish not found")
    return item

@router.post("/", response_model=MenuDishOut, status_code=status.HTTP_201_CREATED)
def create_menu_dish(dish: MenuDishCreate, db: Session = Depends(get_db)):
    db_obj = MenuDishes(**dish.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("menu_dishes_cache")
    return db_obj

@router.put("/{dish_id}", response_model=MenuDishOut)
def update_menu_dish(
    dish_id: int,
    upd: MenuDishUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(MenuDishes).get(dish_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu dish not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("menu_dishes_cache")
    return item

@router.delete("/{dish_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_menu_dish(dish_id: int, db: Session = Depends(get_db)):
    item = db.query(MenuDishes).get(dish_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu dish not found")
    db.delete(item)
    db.commit()
    redis_client.delete("menu_dishes_cache")
    return
