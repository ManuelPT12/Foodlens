import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  User? user;

  bool get isLogged => user != null;

  /// Login + fetch completo de User
  Future<void> login(String email, String password) async {
    // 1) obtén solo el user_id
    final id = await _api.loginUser(email: email, password: password);
    // 2) recupera el objeto User completo
    user = await _api.fetchUserById(id);
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
