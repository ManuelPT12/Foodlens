import yaml
import torch
from easydict import EasyDict as edict
from train import train

def main():
    # Cargar config
    with open("config_files/es_config.yaml", 'r', encoding='utf-8') as f:
        cfg = yaml.safe_load(f)

    opt = edict(cfg)
    opt.character = opt.number + opt.symbol + opt.lang_char

    # Asegurar que usamos CPU si no hay CUDA
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    opt.device = device  # por si tu modelo lo usa

    # Cargar el modelo preentrenado manualmente en CPU si es necesario
    def safe_load(path):
        return torch.load(path, map_location=device)

    # Parchamos el método justo antes de llamarlo desde train()
    torch.safe_load = safe_load  # añadimos una función de utilidad

    # Ejecutar entrenamiento
    train(opt)

if __name__ == '__main__':
    main()
