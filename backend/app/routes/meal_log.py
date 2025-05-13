from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import MealLog
from app.schemas.meal_log_schema import MealLogCreate, MealLogOut, MealLogUpdate
import json
from fastapi.encoders import jsonable_encoder

router = APIRouter(prefix="/meal-logs", tags=["Meal Logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MealLogOut, status_code=status.HTTP_201_CREATED)
def create_meal_log(meal_log: MealLogCreate, db: Session = Depends(get_db)):
    db_obj = MealLog(**meal_log.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("meal_logs_cache")
    return db_obj

@router.get("/", response_model=list[MealLogOut])
def get_all_meal_logs(db: Session = Depends(get_db)):
    cached = redis_client.get("meal_logs_cache")
    if cached:
        return json.loads(cached)
    
    items = db.query(MealLog).all()
    # 1) crea instancias Pydantic
    pydantic_objs = [MealLogOut.from_orm(i) for i in items]
    # 2) convierte a tipos JSON-friendly (datetime → ISO string, etc.)
    json_ready = jsonable_encoder(pydantic_objs)
    # 3) guarda en Redis
    redis_client.set("meal_logs_cache", json.dumps(json_ready), ex=60)
    # 4) devuelve la versión JSONable (no hay que .dict() ni nada)
    return json_ready

@router.get("/{meal_log_id}", response_model=MealLogOut)
def get_meal_log(meal_log_id: int, db: Session = Depends(get_db)):
    item = db.query(MealLog).get(meal_log_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal log not found")
    return item

@router.put("/{meal_log_id}", response_model=MealLogOut)
def update_meal_log(
    meal_log_id: int,
    update: MealLogUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(MealLog).get(meal_log_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal log not found")
    for field, value in update:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("meal_logs_cache")
    return item

@router.delete("/{meal_log_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_meal_log(meal_log_id: int, db: Session = Depends(get_db)):
    item = db.query(MealLog).get(meal_log_id)
    if not item:
        raise HTTPException(status_code=404, detail="Meal log not found")
    db.delete(item)
    db.commit()
    redis_client.delete("meal_logs_cache")
    return
