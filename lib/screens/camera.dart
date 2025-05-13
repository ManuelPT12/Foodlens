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

  // Solicitar permiso para la cámara
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  // Tomar la foto usando la cámara
  Future<void> _takePhoto() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () async {
                  Navigator.of(context).pop(); // Cierra el bottom sheet
                  final picked = await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ProcessingImagePage(imagePath: picked.path),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de la galería'),
                onTap: () async {
                  Navigator.of(context).pop(); // Cierra el bottom sheet
                  final picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ProcessingImagePage(imagePath: picked.path),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si no se tiene permiso, muestra un mensaje y un botón para solicitarlo
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Permiso Cámara')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Necesitamos permiso de cámara para continuar'),
              ElevatedButton(
                onPressed: _requestCameraPermission, // Solicitar permisos nuevamente
                child: const Text('Solicitar Permiso'),
              ),
            ],
          ),
        ),
      );
    }

    // Si ya tenemos el permiso, muestra la interfaz para tomar la foto
    return Scaffold(
      appBar: AppBar(title: const Text('Captura de comida')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar foto'),
          onPressed: _takePhoto, // Acción para tomar la foto
        ),
      ),
    );
  }
}
