import 'package:auto_route/auto_route.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/features/wrappers/pages_wrapper.dart';

part 'auto_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WelcomePreviewRoute.page, path: '/welcome_preview_screen', initial: true),
        AutoRoute(page: WelcomeRoute.page, path: '/welcome_screen'),
        AutoRoute(page: MainWrapperRoute.page, path: '/main_wrapper_screen', children: [
          AutoRoute(page: ChatRoute.page, path: 'chat_screen'),
          AutoRoute(
            page: RoutesWrapperRoute.page,
            path: 'pages_wrapper_screen',
            initial: true,
            children: [
              AutoRoute(page: HomeRoute.page, path: 'dialog_screen', initial: true),
            ],
          ),
        ]),
      ];
}
