import 'dart:math' as math;

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/objectbox.g.dart';
import 'package:image_generate/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
  void didUpdateWidget(covariant ChatScreen oldWidget) {
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Spacer(flex: 2),
                            Text(
                              'BrainRoom',
                              style: context.appUrbanistTextTheme.headlineSmall!
                                  .copyWith(fontSize: 40, color: context.appColors.secondary.shade200),
                            ),
                            const Spacer(),
                            Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HintItem(title: 'Remembers what user said\nearlier in the conversation'),
                                HintItem(title: 'Allows user to provide\nfollow-up corrections With Ai'),
                                HintItem(title: 'Limited knowledge of world\nand events after 2021'),
                              ],
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
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
                top: 45,
                right: 0,
                left: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: SizedBox(
                      height: 45,
                      child: Center(
                        child: Text(
                          'New Chat',
                          style: context.appPoppinsTextTheme.labelSmall!.copyWith(fontSize: 22),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 105,
              child: AnimatedOpacity(
                opacity: state.isGenerating ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: AppTextButton(
                  title: 'Stop generating...',
                  titleFontSize: 12,
                  titleColor: context.appColors.contrastComponentsColor.withValues(alpha: 0.7),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  borderRadius: 8,
                  backgroundColor: context.appColors.neutrals6Color,
                  borderColor: context.appColors.neutrals5Color.withValues(alpha: 0.2),
                  borderWidth: 1.5,
                  prefixIcon: Container(
                      decoration: BoxDecoration(
                          color: context.appColors.contrastComponentsColor, borderRadius: BorderRadius.circular(4))),
                  onTap: () => context.read<AiInteractionBloc>().add(AiInteractionStopGenerationEvent()),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: SearchField(
                promptController: promptController,
                isLoading: state.isGenerating || state.isLoading,
              ),
            ),
            Positioned(
              top: 45,
              right: 35,
              child: MoreInfo(),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: TrailingButton(
                icon: AppIcons.chevronLeftSvg,
                iconWidth: 12,
                iconPadding: EdgeInsets.all(16),
                bgBorderRadius: 16,
                margin: EdgeInsets.all(25),
                bgColor: context.appColors.componentsColor,
                highLightColor: context.appColors.neutrals5Color,
                shadowColor: context.appColors.neutrals5Color.withValues(alpha: 0.3),
                onTap: () => AutoRouter.of(context).maybePop(),
              ),
            ),
            // Positioned(
            //     right: 20,
            //     top: 20,
            //     child: TrailingButton(
            //       bgBorderRadius: 100,
            //       bgColor: context.appColors.primary,
            //       icon: AppIcons.listSvg,
            //       iconWidth: 20,
            //       onTap: () async {
            //         await showDialog(
            //             context: context,
            //             builder: (context) {
            //               return Consumer<LogService>(builder: (context, logService, _) {
            //                 if (logService.logs.isEmpty) {
            //                   return Container(
            //                     width: math.min(500, MediaQuery.of(context).size.width),
            //                     height: MediaQuery.of(context).size.height,
            //                     margin: EdgeInsets.all(24),
            //                     padding: EdgeInsets.all(24),
            //                     decoration: BoxDecoration(
            //                         color: context.appColors.secondary.shade400,
            //                         borderRadius: BorderRadius.circular(24)),
            //                     child: Center(
            //                       child: Text('Пусто.'),
            //                     ),
            //                   );
            //                 }
            //                 return Center(
            //                   child: Container(
            //                     width: math.min(500, MediaQuery.of(context).size.width),
            //                     height: MediaQuery.of(context).size.height,
            //                     margin: EdgeInsets.all(24),
            //                     padding: EdgeInsets.all(24),
            //                     decoration: BoxDecoration(
            //                         color: context.appColors.secondary.shade400,
            //                         borderRadius: BorderRadius.circular(24)),
            //                     child: ListView.separated(
            //                       itemCount: logService.logs.length,
            //                       separatorBuilder: (context, index) => Gap(4),
            //                       itemBuilder: (context, index) => Center(
            //                         child: Row(
            //                           spacing: 12,
            //                           children: [
            //                             Text(
            //                               '${logService.logs[index].name}:',
            //                             ),
            //                             Flexible(
            //                               child: Text(
            //                                 logService.logs[index].message,
            //                                 maxLines: 100,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               });
            //             });
            //       },
            //     )),
          ],
        ),
      );
    });
  }
}

class HintItem extends StatelessWidget {
  const HintItem({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: context.appColors.neutrals6Color),
      child: Center(
        child: Text(
          title,
          style: context.appUrbanistTextTheme.labelMedium!
              .copyWith(fontSize: 16, color: context.appColors.secondary.shade100),
        ),
      ),
    );
  }
}

class MoreInfo extends StatelessWidget {
  const MoreInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 45,
        height: 45,
        child: Material(
          color: context.appColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Ink(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.appColors.neutrals5Color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Ink(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.appColors.neutrals5Color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Ink(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.appColors.neutrals5Color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
