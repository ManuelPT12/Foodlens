// lib/screens/dietist_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../providers/chat_provider.dart';
import '../models/chat_message.dart';

class DietistPage extends StatefulWidget {
  const DietistPage({Key? key}) : super(key: key);

  @override
  _DietistPageState createState() => _DietistPageState();
}

class _DietistPageState extends State<DietistPage> {
  late types.User _user;
  late types.User _assistant;
  bool _showWelcome = true;
  String _welcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _user = const types.User(id: 'user');
    _assistant = const types.User(id: 'assistant');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chat = context.read<ChatProvider>();
      if (chat.sessionId == null) {
        await chat.initSession();
      }
      final profile = chat.userProfile;
      if (profile != null && _showWelcome) {
        _welcomeMessage =
            'Hola ${profile.firstName}, soy tu asistente dietético inteligente.\n'
            'Veo que tienes ${profile.age} años, mides ${profile.height.toInt()} cm y pesas ${profile.weight.toInt()} kg.\n'
            'Puedo responder cualquier pregunta sobre tu dieta y salud. Por favor, consulta a tu médico antes de tomar cualquier decisión médica.\n'
            '¿Qué te gustaría preguntar?';
        setState(() {});
      }
    });
  }

  Future<void> _handleSend(String text) async {
    if (_showWelcome) {
      setState(() => _showWelcome = false);
    }
    await context.read<ChatProvider>().send(text);
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    // Mientras no tengamos sesión, spinner
    if (chat.sessionId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Construye la lista de mensajes para la UI:
    final uiMessages = <types.Message>[];

    // 1) Mensaje de bienvenida (solo si _welcomeText ya está asignado)
    if (_showWelcome && _welcomeMessage.isNotEmpty) {
      uiMessages.add(
        types.TextMessage(
          author: _assistant,
          text: _welcomeMessage,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: 'welcome',
        ),
      );
    }

    // 2) Todos los mensajes de usuario y assistant, excluyendo system
    for (var m in chat.history.where((m) => m.role != Role.system)) {
      final author = m.role == Role.user ? _user : _assistant;
      uiMessages.add(
        types.TextMessage(
          author: author,
          text: m.content,
          createdAt: m.timestamp,
          id: UniqueKey().toString(),
        ),
      );
    }

    uiMessages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    final theme = DefaultChatTheme(
      primaryColor: const Color(0xFF6A1B9A),
      sentMessageBodyTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      sentMessageCaptionTextStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
      ),

      secondaryColor: const Color.fromARGB(255, 236, 231, 216),
      receivedMessageBodyTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
      receivedMessageCaptionTextStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 12,
      ),
      inputTextDecoration: const InputDecoration.collapsed(
        hintText: 'Mensaje',
      ),
      backgroundColor: Colors.white,
      // inputBackgroundColor: Colors.white,
      // inputTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
    );

    return Scaffold(
      body: SafeArea(
        child: Chat(
          theme: theme,
          messages: uiMessages,
          onSendPressed: (partial) => _handleSend(partial.text),
          user: const types.User(id: 'user'),
          // inputOptions: const InputOptions(enableSuggestions: true, autofocus: true),
        ),
      ),
    );
  }
}
