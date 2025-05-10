from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import Allergens
from schemas.allergens_schema import AllergenOut, AllergenCreate
from app.database import redis_client
import json

router = APIRouter(prefix="/allergens", tags=["Allergens"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[AllergenOut])
def get_all_allergens(db: Session = Depends(get_db)):
    cached_data = redis_client.get("allergens_cache")
    if cached_data:
        return json.loads(cached_data)
    allergens = db.query(Allergens).all()
    result = [AllergenOut.from_orm(a).dict() for a in allergens]
    redis_client.set("allergens_cache", json.dumps(result), ex=60)
    return result

@router.post("/", response_model=AllergenOut)
def create_allergen(allergen: AllergenCreate, db: Session = Depends(get_db)):
    new_allergen = Allergens(**allergen.dict())
    db.add(new_allergen)
    db.commit()
    db.refresh(new_allergen)
    redis_client.delete("allergens_cache")  # Limpiar la caché
    return new_allergen