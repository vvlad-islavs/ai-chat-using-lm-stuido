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
        child: AutoRouter(),
      ),
    );
  }
}

