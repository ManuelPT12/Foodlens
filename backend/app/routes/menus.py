from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from models.models import Menus
from schemas.menus_schema import MenuOut, MenuCreate
from app.database import redis_client
import json

router = APIRouter(prefix="/menus", tags=["Menus"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[MenuOut])
def get_all_menus(db: Session = Depends(get_db)):
    cached_menus = redis_client.get("menus_cache")
    if cached_menus:
        return json.loads(cached_menus)
    menus = db.query(Menus).all()
    menus_data = [MenuOut.from_orm(menu).dict() for menu in menus]
    redis_client.set("menus_cache", json.dumps(menus_data), ex=60)
    return menus_data

@router.post("/menus")
def create_menu(menu: MenuCreate, db: Session = Depends(get_db)):
    db_menu = Menus(**menu.dict())
    db.add(db_menu)
    db.commit()
    db.refresh(db_menu)
    return db_menu