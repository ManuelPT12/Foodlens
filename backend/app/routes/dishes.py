from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import Dishes
from schemas.dishes_schema import DishOut, DishCreate
from app.database import redis_client
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
    cached_dishes = redis_client.get("dishes_cache")
    if cached_dishes:
        return json.loads(cached_dishes)
    dishes = db.query(Dishes).all()
    dishes_data = [DishOut.from_orm(dish).dict() for dish in dishes]
    redis_client.set("dishes_cache", json.dumps(dishes_data), ex=60)
    return dishes_data

@router.post("/", response_model=DishOut)
def create_dish(dish: DishCreate, db: Session = Depends(get_db)):
    new_dish = Dishes(**dish.dict())
    db.add(new_dish)
    db.commit()
    db.refresh(new_dish)
    redis_client.delete("dishes_cache")  # Limpiar la caché
    return new_dish