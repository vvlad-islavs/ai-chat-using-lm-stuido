import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/widgets/widgets.dart';

@RoutePage()
class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  final _isOpenSideMenu = ValueNotifier(false);
  Offset? _startDragPoint;

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
          body: GestureDetector(
            onHorizontalDragStart: (details) {
              // Если меню закрыто и не было еще никакого жеста.
              if (_startDragPoint == null && !_isOpenSideMenu.value) {
                _startDragPoint = details.globalPosition;
              }
            },
            onHorizontalDragEnd: (details) {
              debugPrint('End x: ${details.globalPosition.dx}');
              debugPrint('Start x: ${_startDragPoint?.dx}');

              // Если дельта между начальной точкой жеста и конечной превышает 100 и меню закрыто, тогда открываем меню.
              if (details.globalPosition.dx > (_startDragPoint?.dx ?? 10000) + 60 && !_isOpenSideMenu.value) {
                _isOpenSideMenu.value = true;
              }
              // В любом случае по завершение жеста сбрасываем начальное значение.
              _startDragPoint = null;
            },
            onHorizontalDragUpdate: (details) {
              //TODO: зависимость степени открытия меню от оффсета
            },
            child: BlocBuilder<AiInteractionBloc, AiInteractionState>(
                builder: (context, state) {
                  return ValueListenableBuilder(
                      valueListenable: _isOpenSideMenu,
                      builder: (context, isOpenMenu, _) {
                        return Stack(
                          children: [
                            IgnorePointer(
                                ignoring: state.isGenerating ? !state.isGenerating : isOpenMenu,
                                child: const AutoRouter()),
                            LeftSideMenu(
                              isOpen: state.isGenerating ? !state.isGenerating : isOpenMenu,
                              onStartHorizontalDrag: (details) {
                                // Если меню открыто и не было еще никакого действия
                                if (_startDragPoint == null && _isOpenSideMenu.value) {
                                  _startDragPoint = details.globalPosition;
                                }
                              },
                              onEndHorizontalDrag: (details) {
                                debugPrint('End x: ${details.globalPosition.dx}');
                                debugPrint('Start x: ${_startDragPoint?.dx}');

                                // Если дельта между начальной точкой жеста и конечной превышает 60 и меню открыто, тогда закрываем меню.
                                if (details.globalPosition.dx < (_startDragPoint?.dx ?? 0) - 40 &&
                                    _isOpenSideMenu.value) {
                                  _isOpenSideMenu.value = false;
                                }
                                // В любом случае по завершение жеста сбрасываем начальное значение.
                                _startDragPoint = null;
                              },
                              onUpdateHorizontalDrag: (details) {
                                //TODO: зависимость степени открытия меню от оффсета
                              },
                            ),
                          ],
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
