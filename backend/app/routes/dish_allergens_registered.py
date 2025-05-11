from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import DishAllergensRegistered
from schemas.dish_allergens_registered_schema import DishAllergenRegisteredOut, DishAllergenRegisteredCreate
from app.database import redis_client
import json

router = APIRouter(prefix="/dish-allergens", tags=["Dish Allergens"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[DishAllergenRegisteredOut])
def get_all_dish_allergens(db: Session = Depends(get_db)):
    cached_dish_allergens = redis_client.get("dish_allergens_cache")
    if cached_dish_allergens:
        return json.loads(cached_dish_allergens)
    dish_allergens = db.query(DishAllergensRegistered).all()
    dish_allergens_data = [DishAllergenRegisteredOut.from_orm(dish_allergen).dict() for dish_allergen in dish_allergens]
    redis_client.set("dish_allergens_cache", json.dumps(dish_allergens_data), ex=60)
    return dish_allergens_data

@router.post("/dish_allergens_registered")
def create_dish_allergen(data: DishAllergenRegisteredCreate, db: Session = Depends(get_db)):
    db_record = DishAllergensRegistered(**data.dict())
    db.add(db_record)
    db.commit()
    return db_record