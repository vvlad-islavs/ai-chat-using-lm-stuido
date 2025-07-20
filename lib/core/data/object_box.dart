import 'dart:developer';

import 'package:image_generate/objectbox.g.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  void initializeBaseTables() {
    /// Инициализация базовых таблиц
  }

  void initializeAdditionalTables() {
    /// Инициализация дополнительных таблиц
  }

  ObjectBox(this.store) {
    initializeBaseTables();
    initializeAdditionalTables();
  }

  ObjectBox._create(this.store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: path.join(docsDir.path, 'pdu_app'));
    return ObjectBox._create(store);
  }

  /// Получить путь к базе данных
  static Future<String> getDatabasePath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docsDir.path, 'pdu_app');
    log('Путь к базе данных: $dbPath');
    return dbPath;
  }
}