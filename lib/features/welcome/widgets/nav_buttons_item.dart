import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_generate/theme.dart';

class NavButtonsItem extends StatelessWidget {
  const NavButtonsItem({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.iconSrc,
    required this.onTap,
    this.iconColor,
  });

  final PageController pageController;
  final int currentPage;
  final String iconSrc;
  final Color? iconColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(12),
            child: SvgPicture.asset(
              iconSrc,
              colorFilter: ColorFilter.mode(
                iconColor ?? appThemeManager.appColors.neutrals2Color,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}