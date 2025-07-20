import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/core.dart';

class LmStudioAiClient extends AbstractLmStudioAiClient {
  LmStudioAiClient({required super.http});

  final _logService = GetIt.I<LogService>();

  @override
  Future<List<AiModel>> getAvailableModels({required Uri uri, required String apiKey}) async {
    // Создаем заголовки, для локальной сети не нужна авторизация/API-KEY

    _logService.addLog(log: Log(name: 'TempModelsUri', message: Env.modelsLink));
    _logService.addLog(log: Log(name: 'TempChatUri', message: Env.chatLink));
    _logService.addLog(log: Log(name: 'TempApiKey', message: Env.apiKey));
    final headers = {'Content-Type': 'application/json', 'api-key': apiKey};

    final response = await http.send(url: uri, method: 'GET', headers: headers);

    List<AiModel> models = [];

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final data = json.decode(responseBody)['data'] as List<dynamic>;

      debugPrint(data.toString());
      for (final (model as Map<String, dynamic>) in data) {
        models.add(AiModel.fromJson(model));

        log('${model['id']}', name: 'ID');
        log('${model['object']}', name: 'Object');
        log('${model['owned_by']}', name: 'OwnedBy');
      }

      return models;
    } else {
      debugPrint('Ошибка при получении моделей: ${response.statusCode}, ${response.headers}');



      return [];
    }
  }

  @override
  Future sendFutureRequest(String modelId) {
    // TODO: implement sendFutureRequest
    throw UnimplementedError();
  }

  @override
  Stream<String> sendStreamRequest({
    required String modelId,
    required Uri uri,
    required String apiKey,
    required List<Message> messages,
    double temperature = 0.7,
    int maxTokens = -1,
  }) async* {
    // Создаем и кодируем тело запроса.
    final lmStudioBody = utf8.encode(json.encode({
      'model': modelId,
      'messages': messages.map((e) => e.toJson()).toList(),
      "temperature": temperature,
      "max_tokens": maxTokens,
      "stream": true,
    }));

    // Создаем заголовки, для локальной сети не нужна авторизация/API-KEY
    final headers = {'Content-Type': 'application/json', 'api-key': apiKey};

    final response = await http.send(
      url: uri,
      method: 'POST',
      headers: headers,
      body: lmStudioBody,
    );

    if (response.statusCode != 200) {
      throw HttpException('Status ${response.statusCode}');
    }

    await for (final line in response.transform(utf8.decoder).transform(const LineSplitter())) {
      yield line;
    }
  }

  @override
  void setModel(int id) {
    // TODO: implement setModel
  }
}
