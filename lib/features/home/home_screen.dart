import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/theme.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(
              flex: 4,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppIcons.logoSvg,
                ),
                const Gap(32),
                Text(
                  'Welcome to\nBrainRoom',
                  textAlign: TextAlign.center,
                  style: context.appUrbanistTextTheme.headlineSmall!.copyWith(fontSize: 40),
                ),
              ],
            ),
            Spacer(
              flex: 2,
            ),
            CustomButton(
              title: 'Get Started',
              titleFontSize: 15,
              titleColor: context.appColors.white,
              height: 62,
              borderRadius: 16,
              backgroundColor: context.appColors.contrastComponentsColor,
              borderColor: context.appColors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 40),
              onTap: () => AutoRouter.of(context).replaceAll([MainWrapperRoute()]),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
