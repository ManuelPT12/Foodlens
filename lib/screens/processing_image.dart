import 'dart:io';

import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/meal_log.dart';
import 'result_image.dart';

class ProcessingImagePage extends StatefulWidget {
  final String imagePath;
  const ProcessingImagePage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _ProcessingImagePageState createState() => _ProcessingImagePageState();
}

class _ProcessingImagePageState extends State<ProcessingImagePage> {
  @override
  void initState() {
    super.initState();
    _scanImage();
  }

  Future<void> _scanImage() async {
    try {
      // Llama al API definido en lib/services/api.dart (detectar el texto)
      final String result = await ApiService.scanFood(File(widget.imagePath));

      // Llama al API definido en lib/services/api.dart (análisis nutricional)
      final nutrition = await ApiService.analyzeDish(result);

      MealLog mealLog = MealLog(
        id: 0,
        // userId: await ApiService.getCurrentUserId(), // Obtener id del usuario que ha hehco login
        userId: 0,
        mealDate: DateTime.now(),
        mealTypeId: 1, // Por defecto desayuno, después lo modifica el usuario
        dishName: result.split('\n').first, // primera línea como nombre
        description: result,
        calories: nutrition['calories'],
        protein: (nutrition['protein'] as num).toDouble(),
        carbs: (nutrition['carbs'] as num).toDouble(),
        fat: (nutrition['fat'] as num).toDouble(),
        imageUrl: null, // o súbela antes y pon la URL
        createdAt: DateTime.now(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultImagePage(result: mealLog),
        ),
      );
    } catch (e) {
      // Manejo básico de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la imagen: $e')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Procesando…')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analizando imagen, por favor espera…'),
          ],
        ),
      ),
    );
  }
}