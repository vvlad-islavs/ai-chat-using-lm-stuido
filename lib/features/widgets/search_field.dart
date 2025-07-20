import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.promptController,
    required this.isLoading,
  });

  final TextEditingController promptController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: context.appColors.enabledBorder),
                color: context.appColors.secondary.shade200.withValues(alpha: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: TextField(
                  controller: promptController,
                  enabled: !isLoading,
                  minLines: 1,
                  maxLines: 1,
                  style: context.appTextTheme.labelMedium?.copyWith(color: context.appColors.secondary[25]),
                  decoration: InputDecoration(
                    hintStyle: context.appTextTheme.labelMedium?.copyWith(color: context.appColors.secondary[50]),
                    hintText: 'Ввести новый запрос...',
                    labelStyle: context.appTextTheme.titleMedium?.copyWith(color: context.appColors.secondary[50]),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) async {
                    // При отправке очищаем поле ввода.
                    promptController.clear();

                    context.read<AiInteractionBloc>().add(AiInteractionSendRequestStreamEvent(message: text));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
