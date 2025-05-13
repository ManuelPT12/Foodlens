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
      // Llama al API definido en lib/services/api.dart
      final String result = await ApiService.scanFood(File(widget.imagePath));
        MealLog mealLog = MealLog(
        id: 0, 
        userId: 0,
        mealDate: DateTime.now(),
        mealTypeId: 1,
        dishName: result.split('\n').first,
        description: result,
        calories: 0,
        protein: 0.0,
        carbs: 0.0,
        fat: 0.0,
        imageUrl: null,
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