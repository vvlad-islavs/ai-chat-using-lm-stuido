import 'package:image_generate/core/core.dart';

class AiModelsService {
  late AiModel _currentAiModel;
  List<AiModel> _availableModels = [];

  List<AiModel> get availableModels => _availableModels;

  // Пример обращения к lmStudio, работает только в локальной сети
  //   curl http://localhost:1234/v1/chat/completions \
  //   -H "Content-Type: application/json" \
  //   -d '{
  //   "model": "google/gemma-3-12b",
  //   "messages": [
  //   { "role": "system", "content": "Always answer in rhymes. Today is Thursday" },
  //   { "role": "user", "content": "What day is it today?" }
  //   ],
  //   "temperature": 0.7, // насколько будет следовать системному промпту -  "role": "system" (1 - максимально, 0 - минимально)
  //   "max_tokens": -1, //Максимальное количество используемых токенов
  //   "stream": false // возвращать готовый ответ или поток генерации
  // }'

  // При инициализации захардкожена выбранная модель, тк LM Studio не дает возможность поменять модель из кода.
  AiModelsService()
      : _currentAiModel = AiModel(
          id: Env.modelName,
          object: 'model',
          ownedBy: 'organization_owner',
        );

  set availableModels(List<AiModel> models) => _availableModels = models;

  AiModel get currentActiveAiModel => _currentAiModel;

  set currentActiveAiModel(AiModel aiModel) => _currentAiModel = aiModel;
}
