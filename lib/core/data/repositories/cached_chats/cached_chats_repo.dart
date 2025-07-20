import 'package:image_generate/core/core.dart';
import 'package:objectbox/objectbox.dart';

class CachedChatsRepo extends AbstractCachedChatsRepo {
  @override
  Future<int> createChat() async {
    final chatDto = ChatDto()
      ..chatName = 'New Chat'
      ..messages = [];

    return await box.putAsync(chatDto);
  }

  @override
  Future<List<ChatDto>> getAllChats() async {
    final List<ChatDto> chats = await box.getAllAsync();

    return chats;
  }

  @override
  Future<ChatDto> getChatById(int id) async {
    final chat = await box.getAsync(id);

    return chat ?? ChatDto();
  }

  @override
  Future<ChatDto> updateChat(Chat chat) async {
    // Обновляем Dto с тем же id и новыми параметрами.
    final chatDto = ChatDto()
      ..id = chat.id
      ..chatName = chat.name
      ..messages = chat.messages;

    // Загружаем обновленную модель.
    await box.putAsync(chatDto, mode: PutMode.update);

    // Возвращем обновленный ChatDto по тому же id.
    return await box.getAsync(chat.id) ?? ChatDto();
  }

  @override
  Future<void> removeChat(int id) async {
    await box.removeAsync(id);
  }
}
