enum Role { system, user, assistant }

class ChatMessage {
  final Role role;
  final String content;
  final int timestamp;  // nuevo campo

  ChatMessage(this.role, this.content)
    : timestamp = DateTime.now().millisecondsSinceEpoch;
}
