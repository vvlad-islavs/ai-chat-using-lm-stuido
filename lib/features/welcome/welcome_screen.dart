import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/theme.dart';

@RoutePage()
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
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
              const Gap(48),
              CustomButton(
                title: 'Log in',
                titleFontSize: 18,
                titleColor: context.appColors.white,
                height: 62,
                borderRadius: 100,
                backgroundColor: context.appColors.contrastComponentsColor,
                borderColor: context.appColors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shadow: [
                  BoxShadow(
                      blurRadius: 8, offset: Offset(2, 4), color: context.appColors.logInShadow.withValues(alpha: 0.25))
                ],
                onTap: () => AutoRouter.of(context).replaceAll([MainWrapperRoute()]),
              ),
              CustomButton(
                title: 'Sign up',
                titleFontSize: 18,
                titleColor: context.appColors.secondaryButtonText,
                height: 60,
                borderRadius: 100,
                backgroundColor: context.appColors.secondaryButtonBackground,
                borderColor: context.appColors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                onTap: () => AutoRouter.of(context).replaceAll([MainWrapperRoute()]),
              ),
              const Gap(32),
              CustomButton(
                title: 'Continue With Accounts',
                backgroundColor: context.appColors.transparent,
                borderColor: context.appColors.transparent,
                titleColor: context.appColors.neutrals5Color,
                titleFontSize: 16,
                onTap: () {},
              ),
              const Gap(24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Sign up',
                      titleFontSize: 18,
                      titleColor: context.appColors.googleLogIn,
                      height: 60,
                      borderRadius: 10,
                      backgroundColor: context.appColors.googleLogIn.withValues(alpha: 0.25),
                      borderColor: context.appColors.transparent,
                      margin: EdgeInsets.only(left: 24),
                      onTap: () => AutoRouter.of(context).replaceAll([MainWrapperRoute()]),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      title: 'Sign up',
                      titleFontSize: 18,
                      titleColor: context.appColors.facebookLogIn,
                      height: 60,
                      borderRadius: 10,
                      backgroundColor: context.appColors.facebookLogIn.withValues(alpha: 0.25),
                      borderColor: context.appColors.transparent,
                      margin: EdgeInsets.only(right: 24),
                      onTap: () => AutoRouter.of(context).replaceAll([MainWrapperRoute()]),
                    ),
                  ),
                ],
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}
