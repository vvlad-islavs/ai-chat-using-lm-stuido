import 'package:image_generate/core/core.dart';

class Chat {
  final int id;
  final String name;
  final List<Message> messages;
  DateTime _lastUpdate;

  Chat({required this.id, required this.name, required this.messages}) : _lastUpdate = DateTime.now();

  Chat.empty(
    this.id,
  )   : name = 'New Chat',
        messages = [],
        _lastUpdate = DateTime.now();

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      messages: (json['messages'] as List).map((e) => Message.fromJson(e)).toList(),
    );
  }

  DateTime get lastUpdate => _lastUpdate;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'messages': messages.map((m) => m.toJson()).toList()};

  factory Chat.fromDto(ChatDto dto) => Chat(id: dto.id, name: dto.chatName ?? '', messages: dto.messages);

  ChatDto toDto() => ChatDto()
    ..chatName = name
    ..messages = messages;

  Chat copyWith({int? id, String? name, List<Message>? messages}) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
    ).._lastUpdate = DateTime.now();
  }

  Chat withDefaultSystemPrompt({required String prompt}) {
    final List<Message> systemPrompt = [Message(role: Role.system, content: prompt)];

    return copyWith(messages: systemPrompt);
  }
}
