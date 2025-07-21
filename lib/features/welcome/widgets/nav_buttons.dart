import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';

import 'nav_buttons_item.dart';

class NavButtons extends StatelessWidget {
  const NavButtons({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.componentsColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: Offset(0, 40),
            color: context.appColors.contrastComponentsColor.withValues(alpha: 0.12),
          )
        ],
      ),
      child: AnimatedBuilder(
          animation: pageController,
          builder: (context, _) {
            final currentPage =
                (pageController.hasClients && pageController.page != null) ? pageController.page!.round() : 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                NavButtonsItem(
                  pageController: pageController,
                  currentPage: currentPage,
                  iconSrc: AppIcons.arrowLeftSvg,
                  iconColor: currentPage == 0 ? context.appColors.neutrals5Color : context.appColors.neutrals2Color,
                  onTap: currentPage == 0
                      ? null
                      : () => pageController.animateToPage(
                            currentPage - 1,
                            duration: Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                          ),
                ),
                Container(
                  height: 24,
                  width: 2,
                  color: context.appColors.neutrals6Color,
                ),
                NavButtonsItem(
                  pageController: pageController,
                  currentPage: currentPage,
                  iconSrc: AppIcons.arrowRightSvg,
                  onTap: () async {
                    if (currentPage == 2) {
                      await AutoRouter.of(context).replaceAll([WelcomeRoute()]);
                    } else {
                      pageController.animateToPage(
                        currentPage + 1,
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}
