import 'package:auto_route/auto_route.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/features/main_wrapper.dart';

part 'auto_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WelcomeRoute.page, path: '/welcome_screen'),
        AutoRoute(page: WelcomePreviewRoute.page, path: '/welcome_preview_screen', initial: true),
        AutoRoute(
          page: MainWrapperRoute.page,
          path: '/main_wrapper_screen',
          children: [
            AutoRoute(page: HomeRoute.page, path: 'dialog_screen', initial: true),
            AutoRoute(page: ChatRoute.page, path: 'dialog_screen'),
          ],
        ),
      ];
}
