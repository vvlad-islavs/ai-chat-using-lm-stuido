import 'package:get_it/get_it.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/core/data/object_box.dart';

abstract class AbstractCachedChatsRepo {
  final box = GetIt.I<ObjectBox>().store.box<ChatDto>();

  Future<int> createChat();

  Future<List<ChatDto>> getAllChats();

  Future<ChatDto> getChatById(int id);

  Future<void> removeChat(int id);

  Future<ChatDto> updateChat(Chat chat);
}
