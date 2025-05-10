import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'processing_image.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({Key? key}) : super(key: key);

  @override
  _CameraCapturePageState createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  final _picker = ImagePicker();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() => _hasPermission = status.isGranted);
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProcessingImagePage(imagePath: picked.path),
        ),
      );
    } else {
      Navigator.of(context).pop(); // usuario canceló
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Permiso Cámara')),
        body: const Center(
          child: Text('Necesitamos permiso de cámara para continuar'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Captura de comida')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar foto'),
          onPressed: _takePhoto,
        ),
      ),
    );
  }
}
