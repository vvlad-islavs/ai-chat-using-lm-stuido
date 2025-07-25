import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.promptController,
    required this.isLoading,
  });

  final TextEditingController promptController;
  final bool isLoading;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final isEmptyField = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            border: Border.all(color: context.appColors.secondary.shade50.withValues(alpha: 0.5)),
            color: context.appColors.componentsColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(color: context.appColors.neutrals5Color.withValues(alpha: 0.3), blurRadius: 24),
            ]),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: widget.promptController,
                      enabled: !widget.isLoading,
                      maxLines: null,
                      style: context.appUrbanistTextTheme.bodyMedium!.copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        suffixIconConstraints: BoxConstraints(minWidth: 36, maxWidth: 36, minHeight: 36, maxHeight: 36),
                        hintStyle: context.appUrbanistTextTheme.bodyMedium
                            ?.copyWith(color: context.appColors.secondary[50], fontSize: 16),
                        hintText: 'Send a message...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => isEmptyField.value = value.trim().isEmpty,
                      onSubmitted: (text) {
                        // При отправке очищаем поле ввода.
                        widget.promptController.clear();

                        context.read<AiInteractionBloc>().add(AiInteractionSendRequestStreamEvent(message: text));
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: isEmptyField,
                      builder: (context, isEmpty, _) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 32),
                          child: TrailingButton(
                            icon: AppIcons.sendIconSvg,
                            iconColor: isEmpty ? context.appColors.neutrals5Color : context.appColors.white,
                            iconWidth: isEmpty ? 32 : 30,
                            height: isEmpty ? 32 : 30,
                            width: isEmpty ? 36 : 30,
                            padding: EdgeInsets.zero,
                            iconPadding: isEmpty ? EdgeInsets.zero : EdgeInsets.only(right: 4),
                            bgColor:
                                isEmpty ? context.appColors.transparent : context.appColors.contrastComponentsColor,
                            bgBorderRadius: 4,
                            margin: EdgeInsets.zero,
                            onTap: isEmpty ? null : () {},
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
