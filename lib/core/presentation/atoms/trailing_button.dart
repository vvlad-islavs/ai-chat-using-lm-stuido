import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_generate/theme.dart';

class TrailingButton extends StatelessWidget {
  TrailingButton({
    super.key,
    required this.icon,
    this.iconWidth = 22,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.iconColor,
    this.labelText = '',
    this.bgBorderRadius = 0,
    this.iconPadding = 8,
    this.bgColor,
    this.tapBorderRadius = 108,
    this.hoverColor,
    this.shadowColor,
    this.onTap,
  });

  final Color? hoverColor;
  final Color? shadowColor;
  final EdgeInsets padding;
  final Color? bgColor;
  final double bgBorderRadius;
  final double tapBorderRadius;
  final double iconPadding;
  final String icon;
  final Function()? onTap;
  final double iconWidth;
  final EdgeInsets margin;
  final Color? iconColor;
  final String labelText;
  final bool enableAnimation = !Platform.isAndroid && !Platform.isIOS;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    color: context.appColors.transparent,
    child: Material(
      borderRadius: BorderRadius.circular(bgBorderRadius),
      color: bgColor ?? context.appColors.transparent,
      child: InkWell(
        hoverDuration: Duration(milliseconds: enableAnimation ? 250 : 0),
        onTap: onTap,
        hoverColor: hoverColor,
        borderRadius: BorderRadius.all(Radius.circular(tapBorderRadius)),
        highlightColor: context.appColors.secondary.shade600,
        splashColor: context.appColors.secondary.shade800,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Ink(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: context.appColors.transparent,
                  borderRadius: BorderRadius.circular(bgBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor ??  context.appColors.transparent,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? context.appColors.secondary.shade400,
                    BlendMode.srcIn,
                  ),
                  width: iconWidth,
                ),
              ),
              if (labelText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    labelText,
                    style: context.appPoppinsTextTheme.labelMedium!.copyWith(color: context.appColors.secondary.shade400),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

