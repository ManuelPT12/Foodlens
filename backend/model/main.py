from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
import easyocr
from PIL import Image
import numpy as np
import io

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