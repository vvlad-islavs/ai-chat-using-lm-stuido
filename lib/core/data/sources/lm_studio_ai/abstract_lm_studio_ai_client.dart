import 'package:image_generate/core/core.dart';

abstract class AbstractLmStudioAiClient {
  final HttpClientAdapter http;

  AbstractLmStudioAiClient({required this.http});

  /// Возвращает список всех доступных моделей.
  Future<List<AiModel>> getAvailableModels({required Uri uri, required String apiKey});

  /// Отправляет запрос, возвращающий поток генерируемого текста.
  Stream<String> sendStreamRequest({
    required String modelId,
    required Uri uri,
    required String apiKey,
    required List<Message> messages,
    double temperature = 0.7,
    int maxTokens = -1,
  });

  /// Отправляет запрос, возвращающий готовый сгенерированный ответ.
  Future sendFutureRequest(String modelId);

  /// Устнавливает модель по id.
  //TODO: Скорее всего не нужно, тк имя модели устнавливаются при запросе.
  void setModel(int id);
}
