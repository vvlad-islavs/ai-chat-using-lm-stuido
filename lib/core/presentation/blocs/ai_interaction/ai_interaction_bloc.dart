import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/domain/domain.dart';
import 'package:meta/meta.dart';

part 'ai_interaction_event.dart';

part 'ai_interaction_state.dart';

class AiInteractionBloc extends Bloc<AiInteractionEvent, AiInteractionState> {
  final AbstractAiInteractionUsecase aiInteractionUsecase;
  final AiModelsService aiModelsService;

  Message? _generatedMessage;
  Completer? _completer;

  AiInteractionBloc(this.aiInteractionUsecase, this.aiModelsService)
      : super(AiInteractionState(messages: [], generatingMessage: Message.empty(), isGenerating: false)) {
    on<AiInteractionSendRequestStreamEvent>(onSendRequest);
    on<AiInteractionInitialEvent>(onInitial);
    on<AiInteractionStopGenerationEvent>(onStopGeneration);
    on<AiInteractionCreateChatEvent>(onCreateChat);
    on<AiInteractionRemoveChatEvent>(onRemoveChat);
    on<AiInteractionOpenChatEvent>(onOpenChat);
  }

  Future<void> onRemoveChat(AiInteractionRemoveChatEvent event, Emitter<AiInteractionState> emit) async {
    emit(state.copyWith(isLoading: true));

    await aiInteractionUsecase.removeChat(event.id);
    final chats = await aiInteractionUsecase.getAllChats();

    // Если был удален активный чат.
    if (event.id == state.chatId) {
      // Если по итогу остались чаты
      if (chats.isNotEmpty) {
        final chat = chats.first;

        emit(state.copyWith(
            chatName: chat.name, chatId: chat.id, messages: chat.messages, chats: chats, isLoading: false));
        // Если по итогу нет чатов
      } else {
        emit(state.copyWith(chatName: '', chatId: -1, messages: [], chats: [], isLoading: false));
      }
      // Если удален неактивный чат.
    } else {
      emit(state.copyWith(chats: chats, isLoading: false));
    }
  }

  Future<void> onOpenChat(AiInteractionOpenChatEvent event, Emitter<AiInteractionState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Нет смысла снова обращаться к БД за списком чатом, тк они уже есть в состоянии, поэтому берем из состояния.
    final newChat = state.chats.firstWhere((e) => e.id == event.id);

    emit(state.copyWith(chatId: newChat.id, chatName: newChat.name, messages: newChat.messages, isLoading: false));
  }

  Future<void> onCreateChat(AiInteractionCreateChatEvent event, Emitter<AiInteractionState> emit) async {
    emit(state.copyWith(isLoading: true));

    final chat = await aiInteractionUsecase.createChat();
    final allChats = await aiInteractionUsecase.getAllChats();

    emit(state.copyWith(
      chats: allChats,
      chatName: chat.name,
      chatId: chat.id,
      messages: chat.messages,
      isLoading: false,
    ));
  }

  Future<void> onInitial(AiInteractionInitialEvent event, Emitter<AiInteractionState> emit) async {
    GetIt.I<LogService>().addLog(log: Log(name: 'AiBlocInitial', message: ''));
    // Получаем все доступные модели.
    try {

      await aiInteractionUsecase.getAvailableAiModels();
    } catch (e) {
      GetIt.I<LogService>().addLog(log: Log(name: 'GetModelsError', message: e.toString()));
      log(e.toString(), name: 'Error');
      emit(state.copyWith(error: AiError.failedGetModels));
    }
    // Получаем список всех чатов.
    List<Chat> chats = await aiInteractionUsecase.getAllChats();

    late Chat chat;
    late List<Message> messages;

    log('${chats.length}', name: 'Количество чатов');

    // Если чатов нет, то создаем новый и устанавливаем его активным.
    // Иначе используем первый чат из списка доступных.
    if (chats.isEmpty) {
      chat = await aiInteractionUsecase.createChat();

      log('id: ${chat.id}, name: ${chat.name}', name: 'Создан новый чат');

      // Указываем, что сейчас есть только текущий чат.
      chats = [chat];
    } else {
      chat = await aiInteractionUsecase.getChatById(chats.first.id);

      log('id: ${chat.id}, name: ${chat.name}', name: 'Загружен чат');
    }

    await aiInteractionUsecase.getChatById(chat.id).then((value) => messages = value.messages);

    emit(
      state.copyWith(
        isGenerating: false,
        generatingMessage: Message.empty(),
        messages: messages,
        chatId: chat.id,
        chatName: chat.name,
        isLoading: false,
        chats: chats,
      ),
    );
  }

  Future<void> onSendRequest(AiInteractionSendRequestStreamEvent event, Emitter<AiInteractionState> emit) async {
    _completer = Completer();

    List<Message> messages = [...state.messages];

    messages.add(Message(role: Role.user, content: event.message));

    // Создаем объект генерируемого сообщения.
    Message currentGeneratingMessage = Message.empty(role: Role.assistant);

    // Добавляем ответ ии в список сообщений
    messages.add(currentGeneratingMessage);

    // Устанавливаем флаг, что идет генерация и возвращем обновленный список сообщений.
    emit(state.copyWith(isGenerating: true, messages: messages));

    // Пытаемся сделать запрос, в случае ошибки отправляем emit с ошибкой
    try {
      await for (final data in aiInteractionUsecase.sendStreamRequest(
        modelId: aiModelsService.currentActiveAiModel.id,
        messages: messages,
      )) {
        _generatedMessage = Message(role: Role.assistant, content: data);

        // Если _completer был закрыт, то закрываем поток.
        if (_completer != null && _completer!.isCompleted) {
          break;
        }

        emit(state.copyWith(generatingMessage: _generatedMessage));
      }
    } catch (e) {
      GetIt.I<LogService>().addLog(log: Log(name: 'SendRequestError', message: e.toString()));

      log(e.toString(), name: 'Error');
      if (e.toString().contains('Удаленный компьютер отклонил это сетевое подключение')) {
        emit(state.copyWith(error: AiError.aiModelUnAvailable));
      } else {
        emit(state.copyWith(error: AiError.defaultValue));
      }
    }

    // Завершаем _completer после завершения потока генерации текст, если генерация еще не была остановлена.
    if (_completer != null && !(_completer!.isCompleted)) {
      _completer?.complete();
    }

    await _completer?.future.then((_) async {
      if (_generatedMessage != null) {
        log(_generatedMessage!.content, name: _generatedMessage?.role.viewName ?? '');

        // Обновляем список сообщений локально.
        messages.last.clearContent();
        messages.last = _generatedMessage!;
      } else {
        //Удаляем последнее сообщение
        messages.removeLast();
      }
      // обновляем чат в бд и получаем обновленную версию
      final updatedChat =
          await aiInteractionUsecase.updateChat(Chat(id: state.chatId, name: state.chatName, messages: messages));

      // Обновляем список чатов в состоянии
      final updatedAllChats = state.chats.map((e) {
        if (e.id == updatedChat.id) {
          return updatedChat;
        }
        return e;
      }).toList();

      debugPrint(
          '********************************************AllMESSAGES***************************************************');
      for (final message in updatedChat.messages) {
        log(message.content, name: message.role.viewName);
      }
      debugPrint(
          '**********************************************************************************************************');

      emit(state.copyWith(
          messages: updatedChat.messages,
          isGenerating: false,
          generatingMessage: Message.empty(),
          chats: updatedAllChats));

      _generatedMessage = null;
      _completer = null;
    });
  }

  Future<void> onStopGeneration(AiInteractionStopGenerationEvent event, Emitter<AiInteractionState> emit) async {
    // Завершаем _completer вручную если генерация еще не была завершена.
    if (_completer != null && !(_completer!.isCompleted)) {
      _completer?.complete();
    }
  }
}

enum AiError {
  failedGetModels(message: 'Не удалось получить список моделей.'),
  aiModelUnAvailable(message: 'Языковая модель недоступна.'),
  defaultValue(message: 'Ошибка обращения к сервису.');

  final String message;

  const AiError({required this.message});
}
