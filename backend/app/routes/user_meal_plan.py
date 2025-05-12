from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import UserMealPlan
from app.schemas.user_meal_plan_schema import (
    UserMealPlanCreate,
    UserMealPlanOut,
    UserMealPlanUpdate,
)
import json

router = APIRouter(prefix="/user-meal-plans", tags=["User Meal Plans"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[UserMealPlanOut])
def get_all_user_meal_plans(db: Session = Depends(get_db)):
    cached = redis_client.get("user_meal_plan_cache")
    if cached:
        return json.loads(cached)
    items = db.query(UserMealPlan).all()
    data = [UserMealPlanOut.from_orm(i).dict() for i in items]
    redis_client.set("user_meal_plan_cache", json.dumps(data), ex=60)
    return data

@router.get("/{plan_id}", response_model=UserMealPlanOut)
def get_user_meal_plan(plan_id: int, db: Session = Depends(get_db)):
    item = db.query(UserMealPlan).get(plan_id)
    if not item:
        raise HTTPException(status_code=404, detail="User meal plan not found")
    return item

@router.post("/", response_model=UserMealPlanOut, status_code=status.HTTP_201_CREATED)
def create_user_meal_plan(
    payload: UserMealPlanCreate,
    db: Session = Depends(get_db)
):
    db_obj = UserMealPlan(**payload.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("user_meal_plan_cache")
    return db_obj

@router.put("/{plan_id}", response_model=UserMealPlanOut)
def update_user_meal_plan(
    plan_id: int,
    upd: UserMealPlanUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(UserMealPlan).get(plan_id)
    if not item:
        raise HTTPException(status_code=404, detail="User meal plan not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("user_meal_plan_cache")
    return item

@router.delete("/{plan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_meal_plan(plan_id: int, db: Session = Depends(get_db)):
    item = db.query(UserMealPlan).get(plan_id)
    if not item:
        raise HTTPException(status_code=404, detail="User meal plan not found")
    db.delete(item)
    db.commit()
    redis_client.delete("user_meal_plan_cache")
    return
