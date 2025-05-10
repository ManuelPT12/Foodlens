import 'package:flutter/material.dart';
import 'camera_capture.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CameraCapturePage()),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
