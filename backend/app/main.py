from fastapi import FastAPI

from .models import models
from . import database
from .routes import auth

models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()
app.include_router(auth.router)
