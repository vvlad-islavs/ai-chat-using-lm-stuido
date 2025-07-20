import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:image_generate/core/core.dart';

class AiInteractionUsecase extends AbstractAiInteractionUsecase {
  AiInteractionUsecase({required super.lmStudioAiClient, required super.cachedChatsRepo});

  final _logService = GetIt.I<LogService>();

  @override
  Stream<String> sendStreamRequest(
      {required String modelId, required List<Message> messages, double temperature = 0.7, int maxTokens = -1}) async* {
    String generatedContent = '';
    await for (final line in lmStudioAiClient.sendStreamRequest(
        modelId: modelId, uri: Uri.parse(Env.chatLink), apiKey: Env.apiKey, messages: messages)) {
      if (line.startsWith('data:')) {
        final sanitizedAnswer = line.replaceAll('data:', '').trim();

        if (sanitizedAnswer.startsWith('{') && sanitizedAnswer.endsWith('}')) {
          try {
            final Map<String, dynamic> data = json.decode(sanitizedAnswer);
            final content = data['choices']?[0]?['delta']?['content'];
            if (content != null && content is String) {
              generatedContent = '$generatedContent$content';
              yield generatedContent;
            }
          } catch (e) {
            break;
          }
        } else if (sanitizedAnswer.contains('[DONE]')) {
          yield generatedContent;
          return;
        }
      }
    }
  }

  @override
  Future<List<Chat>> getAllChats() async {
    final chatsDto = await cachedChatsRepo.getAllChats();
    final result = chatsDto.map((e) => Chat.fromDto(e)).toList();

    return result;
  }

  @override
  Future<void> removeChat(int id) async {
    await cachedChatsRepo.removeChat(id);
  }

  @override
  Future<Chat> createChat() async {
    // Создаем новый чат, который автоматически генерирует id.
    final chatId = await cachedChatsRepo.createChat();

    // По этому же id получаем объект чата
    final chatDto = await cachedChatsRepo.getChatById(chatId);

    // Задаем дефолтный системный промпт.
    final chat = Chat.fromDto(chatDto).withDefaultSystemPrompt(prompt: 'отвечай на русском');

    return chat;
  }

  @override
  Future<Chat> getChatById(int id) async {
    final chat = await cachedChatsRepo.getChatById(id);

    return Chat.fromDto(chat);
  }

  @override
  Future<Chat> updateChat(Chat chat) async {
    final chatDto = await cachedChatsRepo.updateChat(chat);

    return Chat(id: chatDto.id, name: chatDto.chatName ?? '', messages: chatDto.messages);
  }

  @override
  Future<List<AiModel>> getAvailableAiModels() async {
    // Прописываем логи, отображаемые в приложении.
    _logService.addLog(log: Log(name: 'TempModelsUri', message: Env.modelsLink));
    _logService.addLog(log: Log(name: 'TempChatUri', message: Env.chatLink));
    _logService.addLog(log: Log(name: 'TempApiKey', message: Env.apiKey));

    final modelService = GetIt.I<AiModelsService>();
    final models = await lmStudioAiClient.getAvailableModels(uri: Uri.parse(Env.modelsLink), apiKey: Env.apiKey);
    modelService.availableModels = models;

    return models;
  }
}
