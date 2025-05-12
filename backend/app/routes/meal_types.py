from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import MealTypes
from app.schemas.meal_types_schema import MealTypeCreate, MealTypeOut, MealTypeUpdate
import json

router = APIRouter(prefix="/meal-types", tags=["Meal Types"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[MealTypeOut])
def get_all_meal_types(db: Session = Depends(get_db)):
    cached = redis_client.get("meal_types_cache")
    if cached:
        return json.loads(cached)
    items = db.query(MealTypes).all()
    data = [MealTypeOut.from_orm(i).dict() for i in items]
    redis_client.set("meal_types_cache", json.dumps(data), ex=60)
    return data

@router.get("/{meal_type_id}", response_model=MealTypeOut)
def get_meal_type(meal_type_id: int, db: Session = Depends(get_db)):
    item = db.query(MealTypes).get(meal_type_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal type not found")
    return item

@router.post("/", response_model=MealTypeOut, status_code=status.HTTP_201_CREATED)
def create_meal_type(payload: MealTypeCreate, db: Session = Depends(get_db)):
    db_obj = MealTypes(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("meal_types_cache")
    return db_obj

@router.put("/{meal_type_id}", response_model=MealTypeOut)
def update_meal_type(
    meal_type_id: int,
    upd: MealTypeUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(MealTypes).get(meal_type_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal type not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("meal_types_cache")
    return item

@router.delete("/{meal_type_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_meal_type(meal_type_id: int, db: Session = Depends(get_db)):
    item = db.query(MealTypes).get(meal_type_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal type not found")
    db.delete(item)
    db.commit()
    redis_client.delete("meal_types_cache")
    return
