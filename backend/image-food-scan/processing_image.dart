import 'dart:io';
import 'package:flutter/material.dart';
import 'services/api.dart';
import 'models/food_scan_result.dart';
import 'result_image.dart';

class ProcessingImagePage extends StatefulWidget {
  final String imagePath;
  const ProcessingImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ProcessingImagePage> createState() => _ProcessingImagePageState();
}

class _ProcessingImagePageState extends State<ProcessingImagePage> {
  @override
  void initState() {
    super.initState();
    _scanImage();
  }

  Future<void> _scanImage() async {
    final result = await ApiService.scanFood(File(widget.imagePath));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultImagePage(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Analizando imagen..."),
          ],
        ),
      ),
    );
  }
}
