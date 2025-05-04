from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import MealLog
from schemas.meal_log_schema import MealLogCreate, MealLogOut
from redis_client import redis_client
import json

router = APIRouter(prefix="/meal-logs", tags=["Meal Logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MealLogOut)
def create_meal_log(meal_log: MealLogCreate, db: Session = Depends(get_db)):
    db_meal_log = MealLog(**meal_log.dict())
    db.add(db_meal_log)
    db.commit()
    db.refresh(db_meal_log)
    redis_client.delete("meal_logs_cache")
    return db_meal_log

@router.get("/", response_model=list[MealLogOut])
def get_all_meal_logs(db: Session = Depends(get_db)):
    cached_meal_logs = redis_client.get("meal_logs_cache")
    if cached_meal_logs:
        return json.loads(cached_meal_logs)
    meal_logs = db.query(MealLog).all()
    meal_logs_data = [MealLogOut.from_orm(meal_log).dict() for meal_log in meal_logs]
    redis_client.set("meal_logs_cache", json.dumps(meal_logs_data), ex=60)
    return meal_logs_data