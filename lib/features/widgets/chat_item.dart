import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    super.key,
    required this.chat,
    required this.isActive,
    required this.onTap,
    required this.onRemoveTap,
  });

  final Chat chat;
  final bool isActive;
  final Function() onTap;
  final Function() onRemoveTap;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.transparent,
      child: InkWell(
        onHover: (isHovered) => _isHovered.value = isHovered,
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.isActive ? context.appColors.enabledBorder : context.appColors.disabledBorder,
                    width: widget.isActive ? 2 : 1),
                color: context.appColors.secondary.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          '${widget.chat.name}:',
                          overflow: TextOverflow.ellipsis,
                          style: context.appTextTheme.bodyMedium,
                        ),
                        Flexible(
                          child: Text(
                            widget.chat.messages.firstOrNull?.content ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 4,
                    child: ValueListenableBuilder(
                        valueListenable: _isHovered,
                        builder: (context, isHovered, _) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: isHovered ? 1 : 0,
                            child: Center(
                              child: TrailingButton(
                                iconColor: context.appColors.primary.shade800,
                                iconPadding: 4,
                                icon: AppIcons.xSvg,
                                iconWidth: 16,
                                onTap: widget.onRemoveTap,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
