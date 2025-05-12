from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import Allergens
from app.schemas.allergens_schema import AllergenCreate, AllergenOut, AllergenUpdate
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
    cached = redis_client.get("allergens_cache")
    if cached:
        return json.loads(cached)
    items = db.query(Allergens).all()
    data = [AllergenOut.from_orm(a).dict() for a in items]
    redis_client.set("allergens_cache", json.dumps(data), ex=60)
    return data

@router.get("/{allergen_id}", response_model=AllergenOut)
def get_allergen(allergen_id: int, db: Session = Depends(get_db)):
    item = db.query(Allergens).get(allergen_id)
    if not item:
        raise HTTPException(status_code=404, detail="Allergen not found")
    return item

@router.post("/", response_model=AllergenOut, status_code=status.HTTP_201_CREATED)
def create_allergen(allergen: AllergenCreate, db: Session = Depends(get_db)):
    db_obj = Allergens(**allergen.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("allergens_cache")
    return db_obj

@router.put("/{allergen_id}", response_model=AllergenOut)
def update_allergen(
    allergen_id: int,
    upd: AllergenUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(Allergens).get(allergen_id)
    if not item:
        raise HTTPException(status_code=404, detail="Allergen not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("allergens_cache")
    return item

@router.delete("/{allergen_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_allergen(allergen_id: int, db: Session = Depends(get_db)):
    item = db.query(Allergens).get(allergen_id)
    if not item:
        raise HTTPException(status_code=404, detail="Allergen not found")
    db.delete(item)
    db.commit()
    redis_client.delete("allergens_cache")
    return
