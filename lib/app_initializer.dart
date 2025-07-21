import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/data/object_box.dart';

import 'package:image_generate/theme.dart';
import 'package:provider/provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app.dart';
import 'core/core.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await _initializeBasics();
    // await _initializeApi();
    // await _initializeRepositories();
    await _initializeServices();
    // await _initializeManagers();
    // await _initializeUsecases();
    await _initializeProviders();
  }

  static Future<void> _initializeBasics() async {
    WidgetsFlutterBinding.ensureInitialized();

    AppThemeManager.initialize(brightness: Brightness.light);
  }

  static Future<void> _initializeServices() async {
    final objectBoxPath = await ObjectBox.getDatabasePath();
    debugPrint('Путь к базе данных: $objectBoxPath');

    final directory = Directory(objectBoxPath); // раскомментировать при ошибке с регистрацией GetIt
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
      debugPrint('Старая база ObjectBox удалена');
    }

    if (GetIt.I.isRegistered<ObjectBox>()) {
      GetIt.I.unregister<ObjectBox>();
      debugPrint('Старый экземпляр ObjectBox удалён из GetIt'); // раскомментировать при ошибке с регистрацией GetIt
    }
    final talker = TalkerFlutter.init();
    final talkerLogger = TalkerLogger(
      formatter: const ColoredLoggerFormatter(),
    );
    final objectBox = await ObjectBox.create();

    GetIt.I.registerSingleton<ObjectBox>(objectBox);
    GetIt.I.registerSingleton(talker);
    GetIt.I.registerSingleton(talkerLogger);
    GetIt.I.registerSingleton(AppRouter());
    GetIt.I.registerLazySingleton<AiModelsService>(AiModelsService.new);
    GetIt.I.registerLazySingleton<LogService>(LogService.new);

    await dotenv.load(fileName: ".env");

    FlutterError.onError = (details) {
      // Проверяем, содержит ли ошибка текст, который мы хотим подавить
      final errorMessage = details.exception.toString();
      if (errorMessage.contains("'slot == null': is not true") ||
          errorMessage.contains('BoxConstraints has a negative minimum height')) {
        // Игнорируем эту ошибку
        return;
      }

      // Для всех остальных ошибок используем стандартный обработчик
      GetIt.I<Talker>().handle(details.exception, details.stack);
    };

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: TalkerBlocLoggerSettings(
        printStateFullData: false,
        printEventFullData: false,
        eventFilter: (bloc, event) {
          return true;
        },
        transitionFilter: (bloc, transition) {
          return true;
        },
      ),
    );
  }

  static Future<void> _initializeProviders() async {
    //TODO: пока что здесь, потом убрать в отдельную инициализацию со всеми менеджерами.
    SnackBarManager.init(GlobalKey<ScaffoldMessengerState>());
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: GetIt.I<LogService>()),
        ],
        child: const MyApp(),
      ),
    );
  }
}
