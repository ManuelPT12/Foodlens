from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import UserDiets
from app.schemas.user_diets_schema import UserDietCreate, UserDietOut, UserDietUpdate
import json

router = APIRouter(prefix="/user-diets", tags=["User Diets"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[UserDietOut])
def get_all_user_diets(db: Session = Depends(get_db)):
    cached = redis_client.get("user_diets_cache")
    if cached:
        return json.loads(cached)
    items = db.query(UserDiets).all()
    data = [UserDietOut.from_orm(i).dict() for i in items]
    redis_client.set("user_diets_cache", json.dumps(data), ex=60)
    return data

@router.get("/{user_id}", response_model=UserDietOut)
def get_user_diet(user_id: int, db: Session = Depends(get_db)):
    item = db.query(UserDiets).get(user_id)
    if not item:
        raise HTTPException(status_code=404, detail="User diet not found")
    return item

@router.post("/", response_model=UserDietOut, status_code=status.HTTP_201_CREATED)
def create_user_diet(payload: UserDietCreate, db: Session = Depends(get_db)):
    db_obj = UserDiets(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("user_diets_cache")
    return db_obj

@router.put("/{user_id}", response_model=UserDietOut)
def update_user_diet(
    user_id: int,
    upd: UserDietUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(UserDiets).get(user_id)
    if not item:
        raise HTTPException(status_code=404, detail="User diet not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("user_diets_cache")
    return item

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_diet(user_id: int, db: Session = Depends(get_db)):
    item = db.query(UserDiets).get(user_id)
    if not item:
        raise HTTPException(status_code=404, detail="User diet not found")
    db.delete(item)
    db.commit()
    redis_client.delete("user_diets_cache")
    return
