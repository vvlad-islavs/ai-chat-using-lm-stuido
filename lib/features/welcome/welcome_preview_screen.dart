import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_generate/features/features.dart';
import 'package:image_generate/theme.dart';

@RoutePage()
class WelcomePreviewScreen extends StatefulWidget {
  const WelcomePreviewScreen({super.key});

  @override
  State<WelcomePreviewScreen> createState() => _WelcomePreviewScreenState();
}

class _WelcomePreviewScreenState extends State<WelcomePreviewScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _bottomTitleOffset;
  late Animation<double> _bottomVersionOffset;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: appThemeManager.appColors.backgroundBase,
        systemNavigationBarColor: appThemeManager.appColors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );

    // Запускаем анимацию после задержки
    Future.delayed(const Duration(seconds: 2), () async {
      await _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final screenHeight = MediaQuery.of(context).size.height;

      _bottomTitleOffset = Tween<double>(begin: 36, end: screenHeight / 2 - 20).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      );
      _bottomVersionOffset = Tween<double>(begin: 2400, end: -12).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );

      _scaleAnimation = TweenSequence([
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.05).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.05, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
          weight: 20,
        ),
      ]).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
      );

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return Stack(
              children: [
                FirstTextAndLogo(
                  fadeOutAnimation: _fadeOutAnimation,
                  bottomTitleOffset: _bottomTitleOffset,
                  bottomVersionOffset: _bottomVersionOffset,
                  scaleAnimation: _scaleAnimation,
                ),
                Pages(
                  controller: _controller,
                  pageController: _pageController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
