import 'package:flutter/material.dart';
import '../models/meal_log.dart';
import '../services/api.dart';

class ResultImagePage extends StatefulWidget {
  final MealLog result;
  const ResultImagePage({Key? key, required this.result}) : super(key: key);

  @override
  _ResultImagePageState createState() => _ResultImagePageState();
}

class _ResultImagePageState extends State<ResultImagePage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _kcalCtrl;
  late TextEditingController _protCtrl;
  late TextEditingController _fatCtrl;
  late TextEditingController _carbCtrl;
  late DateTime _mealDate;
  late int _mealTypeId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.result.dishName);
    _descriptionCtrl = TextEditingController(text: widget.result.description);
    _kcalCtrl = TextEditingController(text: widget.result.calories.toString());
    _protCtrl = TextEditingController(text: widget.result.protein.toString());
    _fatCtrl = TextEditingController(text: widget.result.fat.toString());
    _carbCtrl = TextEditingController(text: widget.result.carbs.toString());
    _mealDate = widget.result.mealDate;
    _mealTypeId = widget.result.mealTypeId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _kcalCtrl.dispose();
    _protCtrl.dispose();
    _fatCtrl.dispose();
    _carbCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    // Obtener los valores de los campos editados
    String name = _nameCtrl.text;
    String description = _descriptionCtrl.text;
    int kcal = int.tryParse(_kcalCtrl.text) ?? 0;
    double protein = double.tryParse(_protCtrl.text) ?? 0.0;
    double fat = double.tryParse(_fatCtrl.text) ?? 0.0;
    double carbs = double.tryParse(_carbCtrl.text) ?? 0.0;

    // Crear un objeto MealLog con los datos editados
    MealLog updatedMeal = MealLog(
      id: widget.result.id, // Se mantiene el ID de la comida original
      userId: widget.result.userId, // Usar el userId actual
      mealDate: _mealDate, // Usar la fecha de la comida editada
      mealTypeId: _mealTypeId, // Usar el tipo de comida
      dishName: name,
      description: description,
      calories: kcal,
      protein: protein,
      fat: fat,
      carbs: carbs,
      imageUrl: widget.result.imageUrl, // Mantener la URL de la imagen si no se modifica
      createdAt: widget.result.createdAt, 
    );

    // Aquí se envían los datos a la API
    try {
      bool success = await ApiService.updateMealLog(updatedMeal);

      if (success) {
        // Si la actualización fue exitosa, regresar a la pantalla anterior
        Navigator.of(context).pop();
      } else {
        // Manejo de errores si la actualización falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los cambios')),
        );
      }
    } catch (e) {
      // Manejo de excepciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar comida escaneada')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _kcalCtrl,
              decoration: const InputDecoration(labelText: 'Calorías'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _protCtrl,
              decoration: const InputDecoration(labelText: 'Proteína (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fatCtrl,
              decoration: const InputDecoration(labelText: 'Grasa (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _carbCtrl,
              decoration: const InputDecoration(labelText: 'Carbohidratos (g)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Fecha de la comida: "),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${_mealDate.day}/${_mealDate.month}/${_mealDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _mealTypeId,
              decoration: const InputDecoration(labelText: 'Tipo de comida'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Desayuno')),
                DropdownMenuItem(value: 2, child: Text('Almuerzo')),
                DropdownMenuItem(value: 3, child: Text('Merienda')),
                DropdownMenuItem(value: 4, child: Text('Cena')),
              ],
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _mealTypeId = newValue;
                  });
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _mealDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('es'), // Muestra el calendario en español si lo deseas
    );

    if (picked != null && picked != _mealDate) {
      setState(() {
        _mealDate = picked;
      });
    }
  }
}