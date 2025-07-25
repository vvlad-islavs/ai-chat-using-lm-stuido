import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.index,
    required this.isLast,
    required this.isFirst,
    required this.role,
    required this.text,
  });

  final int index;
  final bool isFirst;
  final bool isLast;
  final Role role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: role == Role.user ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFirst) const Gap(12),
          Padding(
            padding: EdgeInsets.only(left: role == Role.user ? 100 : 0, right: role == Role.assistant ? 100 : 0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: context.appColors.disabledBorder),
                color: context.appColors.secondary.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(
                    '${role.viewName}:',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Flexible(
                    child: Text(
                      text.trim().isEmpty ? 'Загрузка...' : text,
                      maxLines: 10000,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLast) const Gap(86),
        ],
      ),
    );
  }
}
