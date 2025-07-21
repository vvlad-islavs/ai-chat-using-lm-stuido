import 'package:flutter/material.dart';
import 'package:image_generate/theme.dart';

class PagesNavItem extends StatelessWidget {
  const PagesNavItem({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      width: 12.5,
      height: 12.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: context.appColors.contrastComponentsColor.withValues(alpha: isActive ? 1 : 0),
      ),
      child: Center(
        child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: context.appColors.contrastComponentsColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
