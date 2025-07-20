// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDto _$ChatDtoFromJson(Map<String, dynamic> json) => ChatDto()
  ..chatName = json['chatName'] as String?
  ..messagesStr =
      (json['messages'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$ChatDtoToJson(ChatDto instance) => <String, dynamic>{
      'chatName': instance.chatName,
      'messages': instance.messagesStr,
    };
