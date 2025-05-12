import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final _base = dotenv.env['API_BASE_URL']!;
  Future<String> createSession() async {
    final resp = await http.post(Uri.parse('$_base/chat/session'));
    final body = jsonDecode(resp.body);
    return body['session_id'];
  }
  Future<Map<String, dynamic>> sendMessage(String sessionId, String text) async {
    final resp = await http.post(
      Uri.parse('$_base/chat/message'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'session_id': sessionId,'content': text}),
    );
    return jsonDecode(resp.body);
  }
}
