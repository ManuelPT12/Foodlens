from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import UserAllergens
from schemas.user_allergens_schema import UserAllergenOut, UserAllergenCreate
from app.database import redis_client
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
    cached_user_allergens = redis_client.get("user_allergens_cache")
    if cached_user_allergens:
        return json.loads(cached_user_allergens)
    user_allergens = db.query(UserAllergens).all()
    user_allergens_data = [UserAllergenOut.from_orm(user_allergen).dict() for user_allergen in user_allergens]
    redis_client.set("user_allergens_cache", json.dumps(user_allergens_data), ex=60)
    return user_allergens_data

@router.post("/user_allergens")
def create_user_allergen(user_allergen: UserAllergenCreate, db: Session = Depends(get_db)):
    db_ua = UserAllergens(**user_allergen.dict())
    db.add(db_ua)
    db.commit()
    return db_ua