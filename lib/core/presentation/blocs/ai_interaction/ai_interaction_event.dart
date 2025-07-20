part of 'ai_interaction_bloc.dart';

@immutable
sealed class AiInteractionEvent {}

class AiInteractionInitialEvent extends AiInteractionEvent {}

class AiInteractionStopGenerationEvent extends AiInteractionEvent {}

class AiInteractionCreateChatEvent extends AiInteractionEvent {}

class AiInteractionRemoveChatEvent extends AiInteractionEvent {
  final int id;

  AiInteractionRemoveChatEvent({required this.id});
}

class AiInteractionOpenChatEvent extends AiInteractionEvent {
  final int id;

  AiInteractionOpenChatEvent({required this.id});
}

class AiInteractionSendRequestStreamEvent extends AiInteractionEvent {
  final String message;

  AiInteractionSendRequestStreamEvent({required this.message});
}
