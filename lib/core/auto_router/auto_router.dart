import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/features/main_wrapper.dart';

part 'auto_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MainWrapperRoute.page,
          path: '/main_wrapper_screen',
          initial: true,
          children: [
            AutoRoute(page: DialogRoute.page, path: 'dialog_screen', initial: true),
          ],
        ),
      ];
}
