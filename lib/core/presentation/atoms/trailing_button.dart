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
    this.iconPadding,
    this.bgColor,
    this.highLightColor,
    this.hoverColor,
    this.shadowColor,
    this.width,
    this.height,
    this.onTap,
  });

  final Color? hoverColor;
  final Color? shadowColor;
  final Color? highLightColor;
  final EdgeInsets padding;
  final Color? bgColor;
  final double bgBorderRadius;
  final double? width;
  final double? height;
  final EdgeInsets? iconPadding;
  final String icon;
  final Function()? onTap;
  final double iconWidth;
  final EdgeInsets margin;
  final Color? iconColor;
  final String labelText;
  final bool enableAnimation = !Platform.isAndroid && !Platform.isIOS;

  @override
  Widget build(BuildContext context) => Material(
        color: context.appColors.transparent,
        child: Container(
          margin: margin,
          color: context.appColors.transparent,
          child: InkWell(
            hoverDuration: Duration(milliseconds: enableAnimation ? 250 : 0),
            onTap: onTap,
            hoverColor: hoverColor,
            borderRadius: BorderRadius.all(Radius.circular(bgBorderRadius)),
            highlightColor: highLightColor ?? context.appColors.secondary.shade600,
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink(
                    height: height,
                    width: width,
                    padding: iconPadding ?? EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(bgBorderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor ?? context.appColors.transparent,
                          blurRadius: 20,
                          offset: const Offset(6, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: iconWidth,
                        height: iconWidth,
                        child: SvgPicture.asset(
                          icon,
                          colorFilter: ColorFilter.mode(
                            iconColor ?? context.appColors.secondary.shade400,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (labelText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        labelText,
                        style: context.appPoppinsTextTheme.labelMedium!
                            .copyWith(color: context.appColors.secondary.shade400),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
