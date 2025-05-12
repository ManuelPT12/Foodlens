from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import Dishes
from app.schemas.dishes_schema import DishCreate, DishOut, DishUpdate
import json

router = APIRouter(prefix="/dishes", tags=["Dishes"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[DishOut])
def get_all_dishes(db: Session = Depends(get_db)):
    cached = redis_client.get("dishes_cache")
    if cached:
        return json.loads(cached)
    items = db.query(Dishes).all()
    data = [DishOut.from_orm(d).dict() for d in items]
    redis_client.set("dishes_cache", json.dumps(data), ex=60)
    return data

@router.get("/{dish_id}", response_model=DishOut)
def get_dish(dish_id: int, db: Session = Depends(get_db)):
    d = db.query(Dishes).get(dish_id)
    if not d:
        raise HTTPException(status_code=404, detail="Dish not found")
    return d

@router.post("/", response_model=DishOut, status_code=status.HTTP_201_CREATED)
def create_dish(dish: DishCreate, db: Session = Depends(get_db)):
    db_obj = Dishes(**dish.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("dishes_cache")
    return db_obj

@router.put("/{dish_id}", response_model=DishOut)
def update_dish(
    dish_id: int,
    upd: DishUpdate,
    db: Session = Depends(get_db)
):
    d = db.query(Dishes).get(dish_id)
    if not d:
        raise HTTPException(status_code=404, detail="Dish not found")
    for field, value in upd:
        setattr(d, field, value)
    db.commit()
    db.refresh(d)
    redis_client.delete("dishes_cache")
    return d

@router.delete("/{dish_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_dish(dish_id: int, db: Session = Depends(get_db)):
    d = db.query(Dishes).get(dish_id)
    if not d:
        raise HTTPException(status_code=404, detail="Dish not found")
    db.delete(d)
    db.commit()
    redis_client.delete("dishes_cache")
    return
