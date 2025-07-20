import 'package:flutter_dotenv/flutter_dotenv.dart';

//SET YOUR API AND LINKS
class Env {
  static final apiKey = dotenv.get('API_KEY', fallback: 'NEED_YOUR_API_KEY');

  static final chatLink = dotenv.get('CHAT_LINK', fallback: 'NEED_YOUR_CHAT_LINK');

  static final modelsLink = dotenv.get('MODELS_LINK', fallback: 'NEED_YOUR_MODELS_LINK');

  static final modelName = dotenv.get('MODEL_NAME', fallback: 'NEED_YOUR_MODEL_NAME');
}
