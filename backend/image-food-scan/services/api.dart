import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/food_scan_result.dart';

class ApiService {
  static Future<FoodScanResult> scanFood(File image) async {
    final uri = Uri.parse('http://TU_IP:8000/scan-food');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return FoodScanResult.fromJson(json);
    } else {
      throw Exception('Error al analizar la imagen');
    }
  }
}
