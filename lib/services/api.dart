import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.141:8000'; // Cambia si usas físico/Wi-Fi

  Future<bool> loginUser({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('User ID: ${data['user_id']}');
      return true;
    } else {
      return false;
    }
  }

Future<bool> registerUser({
  required String firstName,
  required String lastName,
  required String birthDate,
  required double weight,
  required double height,
  required int age,
  required String gender,
  required String goal,
  required String dietType,
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/register');
  final body = {
    'first_name': firstName,
    'last_name': lastName,
    'birth_date': birthDate,
    'weight': weight,
    'height': height,
    'age': age,
    'gender': gender,
    'goal': goal,
    'diet_type': dietType,
    'email': email,
    'password': password,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    print('ERROR during request: $e');
    return false;
  }
}

}
