import 'dart:math' as math;

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

@RoutePage()
class DialogScreen extends StatefulWidget {
  const DialogScreen({super.key});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  final promptController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appThemeManager.appColors.primary.shade400,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: appThemeManager.appColors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DialogScreen oldWidget) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appThemeManager.appColors.primary.shade400,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: appThemeManager.appColors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiInteractionBloc, AiInteractionState>(listener: (context, state) {
      if (state.error != null && !SnackBarManager.iShowing) {
        SnackBarManager.show(context, state.error?.message ?? '');
      }
    }, builder: (context, state) {
      if (state.isLoading) {
        return AppCircularBar();
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: state.messages.length < 2
                  ? Center(
                      child: Text(
                        'Чем я могу вам помочь?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          if (state.messages[index].role == Role.system) {
                            return const Gap(0);
                          }

                          return const Gap(16);
                        },
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          if (state.messages[index].role == Role.system) {
                            return const Gap(0);
                          }

                          if (state.generatingMessage.isNotEmpty &&
                              state.isGenerating &&
                              index == state.messages.length - 1) {
                            return MessageItem(
                              role: state.messages[index].role,
                              index: index,
                              isFirst: false,
                              isLast: true,
                              text: state.generatingMessage.content,
                            );
                          }
                          return MessageItem(
                            role: state.messages[index].role,
                            index: index,
                            isFirst: index == 0,
                            isLast: index == state.messages.length - 1,
                            text: state.messages[index].content.trim(),
                          );
                        },
                      ),
                    ),
            ),
            if (state.isLoading || state.chatName.isNotEmpty)
              Positioned(
                top: 28,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.appColors.disabledBorder),
                      borderRadius: BorderRadius.circular(12),
                      color: context.appColors.primary.shade300.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      state.chatName.isEmpty
                          ? state.isLoading
                              ? 'Загрузка...'
                              : ''
                          : state.chatName,
                      style: context.appTextTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 60,
              child: AnimatedOpacity(
                opacity: state.isGenerating ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: CustomButton(
                  title: 'Остановить',
                  onTap: () => context.read<AiInteractionBloc>().add(AiInteractionStopGenerationEvent()),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 12,
              right: 12,
              child: SearchField(
                promptController: promptController,
                isLoading: state.isGenerating || state.isLoading,
              ),
            ),
            Positioned(
                right: 20,
                top: 20,
                child: TrailingButton(
                  bgBorderRadius: 100,
                  bgColor: context.appColors.primary,
                  icon: AppIcons.listSvg,
                  iconWidth: 20,
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return Consumer<LogService>(builder: (context, logService, _) {
                            if (logService.logs.isEmpty) {
                              return Container(
                                width: math.min(500, MediaQuery.of(context).size.width),
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.all(24),
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: context.appColors.secondary.shade400,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: Text('Пусто.'),
                                ),
                              );
                            }
                            return Center(
                              child: Container(
                                width: math.min(500, MediaQuery.of(context).size.width),
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.all(24),
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: context.appColors.secondary.shade400,
                                    borderRadius: BorderRadius.circular(24)),
                                child: ListView.separated(
                                  itemCount: logService.logs.length,
                                  separatorBuilder: (context, index) => Gap(4),
                                  itemBuilder: (context, index) => Center(
                                    child: Row(
                                      spacing: 12,
                                      children: [
                                        Text(
                                          '${logService.logs[index].name}:',
                                        ),
                                        Flexible(
                                          child: Text(
                                            logService.logs[index].message,
                                            maxLines: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                  },
                )),
          ],
        ),
      );
    });
  }
}
