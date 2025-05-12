from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import DishAllergensRegistered
from app.schemas.dish_allergens_registered_schema import (
    DishAllergenRegisteredOut,
    DishAllergenRegisteredCreate,
)
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
    cached = redis_client.get("dish_allergens_cache")
    if cached:
        return json.loads(cached)
    items = db.query(DishAllergensRegistered).all()
    data = [DishAllergenRegisteredOut.from_orm(i).dict() for i in items]
    redis_client.set("dish_allergens_cache", json.dumps(data), ex=60)
    return data

@router.get("/{dish_id}/{allergen_id}", response_model=DishAllergenRegisteredOut)
def get_dish_allergen(dish_id: int, allergen_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(DishAllergensRegistered)
        .filter_by(dish_id=dish_id, allergen_id=allergen_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Dish–allergen link not found")
    return item

@router.post(
    "/", response_model=DishAllergenRegisteredOut, status_code=status.HTTP_201_CREATED
)
def create_dish_allergen(
    payload: DishAllergenRegisteredCreate, db: Session = Depends(get_db)
):
    db_obj = DishAllergensRegistered(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("dish_allergens_cache")
    return db_obj

@router.delete(
    "/{dish_id}/{allergen_id}", status_code=status.HTTP_204_NO_CONTENT
)
def delete_dish_allergen(dish_id: int, allergen_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(DishAllergensRegistered)
        .filter_by(dish_id=dish_id, allergen_id=allergen_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="Dish–allergen link not found")
    db.delete(item)
    db.commit()
    redis_client.delete("dish_allergens_cache")
    return
