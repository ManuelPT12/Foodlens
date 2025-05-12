from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import UserAllergens
from app.schemas.user_allergens_schema import (
    UserAllergenCreate,
    UserAllergenOut,
)
import json

router = APIRouter(prefix="/user-allergens", tags=["User Allergens"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[UserAllergenOut])
def get_all_user_allergens(db: Session = Depends(get_db)):
    cached = redis_client.get("user_allergens_cache")
    if cached:
        return json.loads(cached)
    items = db.query(UserAllergens).all()
    data = [UserAllergenOut.from_orm(i).dict() for i in items]
    redis_client.set("user_allergens_cache", json.dumps(data), ex=60)
    return data

@router.get("/{user_id}/{allergen_id}", response_model=UserAllergenOut)
def get_user_allergen(user_id: int, allergen_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserAllergens)
        .filter_by(user_id=user_id, allergen_id=allergen_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="User–allergen link not found")
    return item

@router.post("/", response_model=UserAllergenOut, status_code=status.HTTP_201_CREATED)
def create_user_allergen(
    payload: UserAllergenCreate,
    db: Session = Depends(get_db)
):
    db_obj = UserAllergens(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("user_allergens_cache")
    return db_obj

@router.delete("/{user_id}/{allergen_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_allergen(user_id: int, allergen_id: int, db: Session = Depends(get_db)):
    item = (
        db.query(UserAllergens)
        .filter_by(user_id=user_id, allergen_id=allergen_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="User–allergen link not found")
    db.delete(item)
    db.commit()
    redis_client.delete("user_allergens_cache")
    return
