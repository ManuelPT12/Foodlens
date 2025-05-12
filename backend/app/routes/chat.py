from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
import redis, os, json
from uuid import uuid4
from openai import OpenAI, OpenAIError   

openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY")) 
r = redis.from_url(os.getenv("REDIS_URL"))

router = APIRouter(prefix="/chat", tags=["chat"])

class CreateSessionOut(BaseModel):
    session_id: str

class MessageIn(BaseModel):
    session_id: str
    content: str

class MessageOut(BaseModel):
    role: str
    content: str

@router.post("/session", response_model=CreateSessionOut)
def create_session():
    session_id = str(uuid4())
    # Aquí podrías cargar perfil de usuario y meterlo como primer mensaje
    system = {
      "role": "system",
      "content": "Eres un dietista... Sergio, 32 años, 183 cm, 91 kg, objetivo perder peso"
    }
    r.rpush(session_id, json.dumps(system))
    return {"session_id": session_id}

@router.post("/message", response_model=MessageOut)
def send_message(msg: MessageIn):
    # recupera historial
    history = [json.loads(x) for x in r.lrange(msg.session_id, 0, -1)]
    history.append({"role":"user","content": msg.content})

    try:
        resp = openai_client.chat.completions.create(
            model="gpt-4.1-nano",
            messages=history
        )
    except openai_client.RateLimitError:
        # Captura tanto 429 “rate limit” como “insufficient_quota”
        raise HTTPException(429, "Se ha excedido la cuota de la API de OpenAI.")
    except OpenAIError as e:
        # Otros errores de la API
        raise HTTPException(502, f"Error al llamar a OpenAI: {e}")

    assistant = {
        "role": resp.choices[0].message.role,
        "content": resp.choices[0].message.content
    }
    # guarda y devuelve
    r.rpush(msg.session_id, json.dumps(assistant))
    return assistant