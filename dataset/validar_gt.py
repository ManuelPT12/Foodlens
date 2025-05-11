input_gt = r"C:/Users/Manuel Peña Torres/Foodlens/dataset/es_menu_train/gt.txt"
output_gt = r"C:/Users/Manuel Peña Torres/Foodlens/dataset/es_menu_train/gt_clean.txt"

clean_lines = []
with open(input_gt, 'r', encoding='utf-8') as f:
    for i, line in enumerate(f):
        line = line.strip()
        if not line:
            print(f"❌ Línea {i+1} vacía")
            continue
        if '\t' not in line:
            print(f"❌ Línea {i+1} sin tabulador: {line}")
            continue
        img, label = line.split('\t', 1)
        if img.startswith("img/"):
            img = img[4:]  # Quita el prefijo "img/"
        clean_lines.append(f"{img}\t{label}")

# Escribir archivo limpio
with open(output_gt, 'w', encoding='utf-8') as f:
    f.write('\n'.join(clean_lines))

print(f"\n✅ Archivo limpio guardado como: {output_gt}")
