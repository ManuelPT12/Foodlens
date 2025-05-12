from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal, redis_client
from app.models.models import Menus
from app.schemas.menus_schema import MenuCreate, MenuOut, MenuUpdate
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
    cached = redis_client.get("menus_cache")
    if cached:
        return json.loads(cached)
    items = db.query(Menus).all()
    data = [MenuOut.from_orm(i).dict() for i in items]
    redis_client.set("menus_cache", json.dumps(data), ex=60)
    return data

@router.get("/{menu_id}", response_model=MenuOut)
def get_menu(menu_id: int, db: Session = Depends(get_db)):
    item = db.query(Menus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu not found")
    return item

@router.post("/", response_model=MenuOut, status_code=status.HTTP_201_CREATED)
def create_menu(menu: MenuCreate, db: Session = Depends(get_db)):
    db_obj = Menus(**menu.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    redis_client.delete("menus_cache")
    return db_obj

@router.put("/{menu_id}", response_model=MenuOut)
def update_menu(
    menu_id: int,
    upd: MenuUpdate,
    db: Session = Depends(get_db)
):
    item = db.query(Menus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu not found")
    for field, value in upd:
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    redis_client.delete("menus_cache")
    return item

@router.delete("/{menu_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_menu(menu_id: int, db: Session = Depends(get_db)):
    item = db.query(Menus).get(menu_id)
    if not item:
        raise HTTPException(status_code=404, detail="Menu not found")
    db.delete(item)
    db.commit()
    redis_client.delete("menus_cache")
    return
