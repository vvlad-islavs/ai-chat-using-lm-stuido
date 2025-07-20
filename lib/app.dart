import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/auto_router/auto_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeManager,
      builder: (context, __) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Mobile App',
          theme: appThemeManager.appTheme,
          routerConfig: appRouter.config(
            navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>()), RouteObserver()],
          ),
        );
      },
    );
  }
}
