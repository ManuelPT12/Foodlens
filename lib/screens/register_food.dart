// lib/screens/register_food_page.dart

import 'package:flutter/material.dart';
import '../services/api.dart';
// import '../models/food_scan_result.dart';
// import 'camera_capture.dart';
// import 'processing_image.dart';
// import 'result_image.dart';

class RegisterFoodPage extends StatefulWidget {
  /// Por ejemplo: 'Desayuno', 'Almuerzo', 'Merienda' o 'Cena'
  final String mealType;
  const RegisterFoodPage({Key? key, required this.mealType}) : super(key: key);

  @override
  _RegisterFoodPageState createState() => _RegisterFoodPageState();
}

class _RegisterFoodPageState extends State<RegisterFoodPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Controllers para cada modo
  final _descController     = TextEditingController();
  final _nameController     = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController  = TextEditingController();
  final _fatController      = TextEditingController();
  final _carbsController    = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descController.dispose();
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  Future<void> _handleDescribe() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) return;
    // Navegar a Processing mientras llama al API de descripción:
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (_) => ProcessingImagePage(
    //     imagePath: '', // sin imagen: la página de procesado usará describeFood
    //     useDescription: true,
    //     description: desc,
    //     mealType: widget.mealType,
    //   ),
    // ));
  }

  Future<void> _handleManual() async {
    final name     = _nameController.text.trim();
    final cal      = double.tryParse(_caloriesController.text) ?? 0;
    final prot     = double.tryParse(_proteinController.text)  ?? 0;
    final fat      = double.tryParse(_fatController.text)      ?? 0;
    final carbs    = double.tryParse(_carbsController.text)    ?? 0;
    if (name.isEmpty) return;

    // await ApiService.createMealEntry(
    //   mealType: widget.mealType,
    //   name: name,
    //   calories: cal,
    //   protein: prot,
    //   fat: fat,
    //   carbs: carbs,
    // );

    Navigator.of(context).pop(); // vuelve al Diario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar ${widget.mealType}'),
        backgroundColor: const Color(0xFFFCF6EC),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFF68D2E),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Describir'),
              Tab(text: 'Manual'),
              Tab(text: 'Foto'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1) Describir
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          labelText: 'Describe tu comida',
                          hintText:
                              'Un plato de pollo con arroz y verduras...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF68D2E),
                        ),
                        onPressed: _handleDescribe,
                        child: const Text('Analizar descripción'),
                      ),
                    ],
                  ),
                ),

                // 2) Manual
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la comida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _caloriesController,
                        decoration: const InputDecoration(
                          labelText: 'Calorías (kcal)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _proteinController,
                        decoration: const InputDecoration(
                          labelText: 'Proteína (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _fatController,
                        decoration: const InputDecoration(
                          labelText: 'Grasa (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _carbsController,
                        decoration: const InputDecoration(
                          labelText: 'Carbohidratos (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF68D2E),
                        ),
                        onPressed: _handleManual,
                        child: const Text('Guardar manualmente'),
                      ),
                    ],
                  ),
                ),

                // 3) Foto
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB879),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.camera_alt, size: 28),
                    label: const Text('Tomar foto'),
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (_) => CameraCapturePage(
                      //     mealType: widget.mealType,
                      //   ),
                      // ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
