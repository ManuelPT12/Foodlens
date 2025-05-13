from fastapi import FastAPI, File, UploadFile, HTTPException, Body
from fastapi.responses import JSONResponse
import easyocr
from PIL import Image
import numpy as np
import io
import openai
import os

app = FastAPI()

@app.on_event("startup")
def load_model():
    app.state.ocr_reader = easyocr.Reader(
        ['es'],
        model_storage_directory='.',
        user_network_directory='./user_network',  # donde está latin_g2.pth
        download_enabled=True
    )

@app.post("/scan_food")
async def recognize_text(file: UploadFile = File(...)):
    # Comprobar que es una imagen
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Debes subir una imagen")

    try:
        # Leer la imagen y convertirla en array para EasyOCR
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        image_np = np.array(image)

        # Usar el modelo EasyOCR
        reader = app.state.ocr_reader
        result = reader.readtext(image_np, detail=0)  # detail=0 => solo el texto

        if not result:
            return JSONResponse(status_code=500, content={"text": "No se pudo reconocer texto."})

        return JSONResponse(content={"text": result})

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error procesando la imagen: {str(e)}")
    
@app.post("/analyze_dish")
async def analyze_dish(text: str = Body(...)):
    print(f"Texto recibido para análisis: {text}")
    
    prompt = (
        f"A partir de esta descripción de un plato de comida:\n\n"
        f"{text}\n\n"
        f"Devuélveme solo un JSON con las siguientes claves: 'calories', 'protein', 'carbs', 'fat'. "
        f"Redondea a enteros las calorías y a un decimal el resto. Ejemplo:\n"
        f'{{"calories": 250, "protein": 15.2, "carbs": 30.5, "fat": 10.0}}'
    )

    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )

    content = response.choices[0].message.content.strip()
    return eval(content)  # o usa json.loads(content) si OpenAI responde en JSON válido