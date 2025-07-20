import 'package:image_generate/core/core.dart';

class Message {
  final Role role;
  final String content;

  Message({required this.role, required this.content});

  Message.empty({
    this.role = Role.user,
  }) : content = '';

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(role: Role.fromJsonName(json['role']), content: json['content']);

  bool get isEmpty => content.isEmpty;

  bool get isNotEmpty => content.isNotEmpty;

  Map<String, dynamic> toJson() => {'role': role.jsonName, 'content': content};

  Message copyWith({Role? role, String? content}) => Message(role: role ?? this.role, content: content ?? this.content);

  Message clearContent() => Message(role: role, content: '');
}
