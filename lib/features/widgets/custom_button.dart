import 'package:flutter/material.dart';
import 'package:image_generate/objectbox.g.dart';
import 'package:image_generate/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.margin,
    this.titleFontSize,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.padding,
    this.height,
    this.width,
    this.shadow,
  });

  final String title;
  final Color? titleColor;
  final double? titleFontSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadow;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.transparent,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            child: Ink(
              height: height,
              width: width,
              padding: padding,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor ?? context.appColors.disabledBorder),
                color: backgroundColor ?? context.appColors.secondary.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: shadow ?? [],
              ),
              child: Center(
                child: Text(
                  title,
                  style: context.appPoppinsTextTheme.labelMedium!.copyWith(color: titleColor, fontSize: titleFontSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
