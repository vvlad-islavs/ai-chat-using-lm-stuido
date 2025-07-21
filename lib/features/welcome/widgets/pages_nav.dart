import 'package:flutter/material.dart';
import 'package:image_generate/theme.dart';

import 'page_nav_item.dart';

class PagesNav extends StatelessWidget {
  const PagesNav({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: pageController,
        builder: (context, _) {
          final currentPage =
          (pageController.hasClients && pageController.page != null) ? pageController.page!.round() : 0;
          return Center(
            child: SizedBox(
              height: 18,
              width: 62,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.7),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PagesNavItem(
                            isActive: currentPage == 0,
                          ),
                          PagesNavItem(
                            isActive: currentPage == 1,
                          ),
                          PagesNavItem(
                            isActive: currentPage == 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: (pageController.page ?? 0) * ((62 - 18) / 2),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: context.appColors.contrastComponentsColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}