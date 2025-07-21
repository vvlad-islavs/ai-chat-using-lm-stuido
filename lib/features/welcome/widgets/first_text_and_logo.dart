import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';

class FirstTextAndLogo extends StatelessWidget {
  const FirstTextAndLogo({
    super.key,
    required this.fadeOutAnimation,
    required this.bottomTitleOffset,
    required this.bottomVersionOffset,
    required this.scaleAnimation,
  });

  final Animation<double> fadeOutAnimation;
  final Animation<double> bottomTitleOffset;
  final Animation<double> bottomVersionOffset;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: fadeOutAnimation.value,
          child: Center(
            child: SvgPicture.asset(
              AppIcons.logoSvg,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomTitleOffset.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Center(
              child: Text(
                'BrainRoom',
                style: context.appPoppinsTextTheme.labelSmall!.copyWith(fontSize: 35),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: bottomVersionOffset.value < 24 ? bottomVersionOffset.value : 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version ',
                    style: context.appPoppinsTextTheme.bodySmall!.copyWith(fontSize: 16),
                  ),
                  Text(
                    '1.0',
                    style: context.appPoppinsTextTheme.bodySmall!.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
