import 'dart:convert';

import 'package:image_generate/core/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'chat_dto.g.dart';

@Entity()
@JsonSerializable()
class ChatDto {
  @Id()
  @JsonKey(includeFromJson: false, includeToJson: false)
  int id = 0;

  String? chatName;

  @JsonKey(name: 'messages')
  List<String>? messagesStr;

  ChatDto();

  /// Переводит List<String> в List<Message>
  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Message> get messages {
    return messagesStr?.map((e) => Message.fromJson(json.decode(e) as Map<String, dynamic>)).toList() ?? [];
  }

  /// Переводит List<Message> в List<String>
  set messages(List<Message> messages) => messagesStr = messages.map((e) => json.encode(e.toJson())).toList();

  factory ChatDto.fromJson(Map<String, dynamic> json) => _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}
