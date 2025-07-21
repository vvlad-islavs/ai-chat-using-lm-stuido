import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/core.dart';

@RoutePage()
class MainWrapperScreen extends StatelessWidget {
  const MainWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AbstractAiInteractionUsecase>(
          create: (BuildContext context) => AiInteractionUsecase(
            lmStudioAiClient: LmStudioAiClient(http: DefaultHttpClientAdapter()),
            cachedChatsRepo: CachedChatsRepo(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AiInteractionBloc(
          context.read<AbstractAiInteractionUsecase>(),
          GetIt.I<AiModelsService>(),
        )..add(AiInteractionInitialEvent()),
        child: Scaffold(
          body: AutoTabsRouter.pageView(
            routes: [
              HomeRoute(),
              ChatRoute(),
              HomeRoute(),
            ],
            builder: (context, child, _) {
              final tabsRouter = AutoTabsRouter.of(context);
              return Scaffold(
                // appBar: AppBar(
                //   title: Text(context.topRoute.name),
                //   leading: AutoLeadingButton(),
                // ),
                body: child,
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                  items: [
                    BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
                    BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.chat)),
                    BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.home)),
                  ],
                ),
              );
            },
          ),

        ),
      ),
    );
  }
}
