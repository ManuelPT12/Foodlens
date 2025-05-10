import 'package:flutter/material.dart';
import 'models/food_scan_result.dart';

class ResultImagePage extends StatefulWidget {
  final FoodScanResult result;
  const ResultImagePage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultImagePage> createState() => _ResultImagePageState();
}

class _ResultImagePageState extends State<ResultImagePage> {
  late TextEditingController nameCtrl, caloriesCtrl, proteinCtrl, fatCtrl, carbsCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.result.name);
    caloriesCtrl = TextEditingController(text: widget.result.calories.toString());
    proteinCtrl = TextEditingController(text: widget.result.protein.toString());
    fatCtrl = TextEditingController(text: widget.result.fat.toString());
    carbsCtrl = TextEditingController(text: widget.result.carbs.toString());
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    caloriesCtrl.dispose();
    proteinCtrl.dispose();
    fatCtrl.dispose();
    carbsCtrl.dispose();
    super.dispose();
  }

  void _saveFood() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar alimento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: caloriesCtrl, decoration: const InputDecoration(labelText: "Calorías")),
            TextField(controller: proteinCtrl, decoration: const InputDecoration(labelText: "Proteína")),
            TextField(controller: fatCtrl, decoration: const InputDecoration(labelText: "Grasa")),
            TextField(controller: carbsCtrl, decoration: const InputDecoration(labelText: "Carbohidratos")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveFood, child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
