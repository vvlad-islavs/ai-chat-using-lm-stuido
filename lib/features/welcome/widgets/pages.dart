import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/theme.dart';

class Pages extends StatelessWidget {
  const Pages({
    super.key,
    required AnimationController controller,
    required PageController pageController,
  })  : _controller = controller,
        _pageController = pageController;

  final AnimationController _controller;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !_controller.isCompleted,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _controller.isCompleted ? 1 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppTextButton(
                    title: 'Skip',
                    backgroundColor: context.appColors.transparent,
                    borderColor: context.appColors.transparent,
                    titleColor: context.appColors.neutrals5Color.withValues(alpha: 0.8),
                    titleFontSize: 18,
                    onTap: () => AutoRouter.of(context).replaceAll([WelcomeRoute()]),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Gap(8),
            SizedBox(
              height: 485,
              child: PageView(
                controller: _pageController,
                children: [
                  PageItem(
                    imageSrc: AppIcons.robotPng,
                  ),
                  PageItem(
                    imageSrc: AppIcons.blackRobotPng,
                  ),
                  PageItem(
                    imageSrc: AppIcons.tabletRobotPng,
                  ),
                ],
              ),
            ),
            PagesNav(
              pageController: _pageController,
            ),
            const Gap(16),
            UnderPagesText(),
            const Spacer(),
            const Gap(8),
            NavButtons(
              pageController: _pageController,
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
