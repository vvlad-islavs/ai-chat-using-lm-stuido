import 'package:flutter/material.dart';
import 'package:image_generate/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.transparent,
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.appColors.disabledBorder),
              color: context.appColors.secondary.shade50.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              title,
              style: context.appTextTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}
