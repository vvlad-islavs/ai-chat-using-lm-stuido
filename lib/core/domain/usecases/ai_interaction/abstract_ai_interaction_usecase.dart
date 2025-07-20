import 'package:image_generate/core/core.dart';

abstract class AbstractAiInteractionUsecase {
  late final AbstractLmStudioAiClient lmStudioAiClient;
  late final AbstractCachedChatsRepo cachedChatsRepo;

  AbstractAiInteractionUsecase({
    required this.lmStudioAiClient,
    required this.cachedChatsRepo,
  });

  Stream<String> sendStreamRequest({
    required String modelId,
    required List<Message> messages,
    double temperature = 0.7,
    int maxTokens = -1,
  });

  Future<List<Chat>> getAllChats();

  Future<Chat> createChat();

  Future<Chat> updateChat(Chat chat);

  Future<void> removeChat(int id);

  Future<Chat> getChatById(int id);

  Future<List<AiModel>> getAvailableAiModels();
}
