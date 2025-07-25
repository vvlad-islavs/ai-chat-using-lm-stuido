import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/theme.dart';

class LeftSideMenu extends StatelessWidget {
  const LeftSideMenu({
    super.key,
    required this.isOpen,
    required this.onStartHorizontalDrag,
    required this.onEndHorizontalDrag,
    required this.onUpdateHorizontalDrag,
  });

  final bool isOpen;
  final Function(DragStartDetails) onStartHorizontalDrag;
  final Function(DragEndDetails) onEndHorizontalDrag;
  final Function(DragUpdateDetails) onUpdateHorizontalDrag;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: 0,
      bottom: 0,
      left: isOpen ? 0 : -300,
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onHorizontalDragStart: onStartHorizontalDrag,
        onHorizontalDragEnd: onEndHorizontalDrag,
        onHorizontalDragUpdate: onUpdateHorizontalDrag,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: isOpen ? 3 : 0),
          duration: Duration(milliseconds: 300),
          builder: (context, value, _) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
              child: Container(
                width: 276,
                margin: const EdgeInsets.all(12).copyWith(right: 100),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                // duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  border: Border.all(color: context.appColors.disabledBorder),
                  borderRadius: BorderRadius.circular(12),
                  color: context.appColors.primary.shade200.withValues(alpha: 0.3),
                ),
                child: Column(
                  spacing: 12,
                  children: [
                    const Gap(36),
                    // const Text(
                    //   'Новый чат',
                    //   style: TextStyle(fontSize: 20),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Чаты',
                            style: TextStyle(fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          BlocBuilder<AiInteractionBloc, AiInteractionState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return Expanded(child: AppCircularBar());
                              }
                              return Flexible(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      if (index == state.chats.length - 1) {
                                        return Gap(12);
                                      }
                                      return Gap(4);
                                    },
                                    itemCount: state.chats.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == state.chats.length) {
                                        return AppTextButton(
                                            title: 'Новый чат',
                                            onTap: () {
                                              context.read<AiInteractionBloc>().add(AiInteractionCreateChatEvent());
                                            });
                                      }
                                      return ChatItem(
                                        chat: state.chats[index],
                                        isActive: state.chatId == state.chats[index].id,
                                        onTap: () => context
                                            .read<AiInteractionBloc>()
                                            .add(AiInteractionOpenChatEvent(id: state.chats[index].id)),
                                        onRemoveTap: () => context
                                            .read<AiInteractionBloc>()
                                            .add(AiInteractionRemoveChatEvent(id: state.chats[index].id)),
                                      );
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),
                    const Text(
                      'Настройки',
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Выйти',
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
