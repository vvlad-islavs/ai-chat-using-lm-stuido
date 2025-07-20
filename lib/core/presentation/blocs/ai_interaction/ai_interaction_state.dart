part of 'ai_interaction_bloc.dart';

class AiInteractionState {
  final List<Message> messages;
  final int chatId;
  final String chatName;
  final Message generatingMessage;
  final bool isGenerating;
  final AiError? error;
  final bool isLoading;
  List<Chat> chats;

  AiInteractionState({
    required this.messages,
    required this.generatingMessage,
    required this.isGenerating,
    this.error,
    this.chatId = -1,
    this.chatName = '',
    this.isLoading = true,
  }) : chats = [];

  AiInteractionState copyWith({
    String? chatName,
    int? chatId,
    List<Message>? messages,
    Message? generatingMessage,
    bool? isGenerating,
    AiError? error,
    bool? isLoading,
    List<Chat>? chats,
  }) =>
      AiInteractionState(
        chatName: chatName ?? this.chatName,
        chatId: chatId ?? this.chatId,
        messages: messages ?? this.messages,
        generatingMessage: generatingMessage ?? this.generatingMessage,
        isGenerating: isGenerating ?? this.isGenerating,
        isLoading: isLoading ?? this.isLoading,
        // Всегда передаем новое значение, чтобы не прописывать каждый рза нулевую ошибку
        error: error,
      )..chats = chats ?? this.chats;
}
