import 'package:flutter/material.dart';
import '../models/meal_log.dart';

class ResultImagePage extends StatefulWidget {
  final MealLog result;
  const ResultImagePage({Key? key, required this.result}) : super(key: key);

  @override
  _ResultImagePageState createState() => _ResultImagePageState();
}

class _ResultImagePageState extends State<ResultImagePage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _kcalCtrl;
  late TextEditingController _protCtrl;
  late TextEditingController _fatCtrl;
  late TextEditingController _carbCtrl;

  @override
  void initState() {
    super.initState();
    // _nameCtrl = TextEditingController(text: widget.result.name);
    _kcalCtrl = TextEditingController(text: widget.result.calories.toString());
    _protCtrl = TextEditingController(text: widget.result.protein.toString());
    _fatCtrl = TextEditingController(text: widget.result.fat.toString());
    _carbCtrl = TextEditingController(text: widget.result.carbs.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _protCtrl.dispose();
    _fatCtrl.dispose();
    _carbCtrl.dispose();
    super.dispose();
  }

  void _save() {
    // Aquí podrías enviar al backend o al bloc/provider
    // tus valores editados: name, calories, protein, fat, carbs.
    Navigator.of(context).pop(); // o navega a donde haga falta
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
              controller: _kcalCtrl,
              decoration: const InputDecoration(labelText: 'Calorías'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _protCtrl,
              decoration:
                  const InputDecoration(labelText: 'Proteína (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fatCtrl,
              decoration: const InputDecoration(labelText: 'Grasa (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _carbCtrl,
              decoration:
                  const InputDecoration(labelText: 'Carbohidratos (g)'),
              keyboardType: TextInputType.number,
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
}