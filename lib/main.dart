import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'app_initializer.dart';

void main() async {
  runZonedGuarded(
    () async {
      await AppInitializer.initialize();
    },
    (error, stack) => GetIt.I<Talker>().handle(error, stack),
  );
}
