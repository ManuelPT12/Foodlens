// lib/providers/chat_provider.dart

import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/user.dart';
import '../services/chat.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  User? userProfile;
  String? sessionId;
  List<ChatMessage> history = [];

  /// ProxyProvider llamará esto al hacer login
  void setUserProfile(User user) {
    userProfile = user;
    sessionId = null;
    history.clear();
    notifyListeners();
  }

  Future<void> initSession() async {
    if (userProfile == null) {
      throw Exception('No hay perfil de usuario para inicializar chat');
    }
    sessionId = await _service.createSession();
    history = [
      ChatMessage(
        Role.system,
        'Eres un dietista experto. Usuario: '
        '${userProfile!.firstName} ${userProfile!.lastName}, '
        '${userProfile!.age} años, ${userProfile!.height.toInt()} cm, '
        '${userProfile!.weight.toInt()} kg, objetivo: ${userProfile!.goal}.'
      )
    ];
    notifyListeners();
  }

  Future<void> send(String text) async {
    if (sessionId == null) await initSession();
    history.add(ChatMessage(Role.user, text));
    notifyListeners();
    final resp = await _service.sendMessage(sessionId!, text);
    history.add(ChatMessage(Role.assistant, resp['content']));
    notifyListeners();
  }
}
