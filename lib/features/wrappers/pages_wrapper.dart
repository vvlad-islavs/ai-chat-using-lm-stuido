import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_generate/core/core.dart';
import 'package:image_generate/theme.dart';

@RoutePage()
class PagesWrapperScreen extends StatelessWidget {
  const PagesWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutoTabsRouter.pageView(
        routes: [
          HomeRoute(),
          HomeRoute(),
          HomeRoute(),
          HomeRoute(),
        ],
        builder: (context, child, _) {
          return Scaffold(
            body: child,
            bottomNavigationBar: AppBottomNavBar(
              items: [
                AppBottomNavBarItem(
                  icon: AppIcons.homeSvg,
                  activeColor: context.appColors.neutrals1Color,
                  onTap: () => AutoTabsRouter.of(context).setActiveIndex(0),
                ),
                AppBottomNavBarItem(
                  icon: AppIcons.itemsSvg,
                  activeColor: context.appColors.neutrals1Color,
                  onTap: () => AutoTabsRouter.of(context).setActiveIndex(1),
                ),
                AppBottomNavBarItem(
                  icon: AppIcons.clockSvg,
                  activeColor: context.appColors.neutrals1Color,
                  onTap: () => AutoTabsRouter.of(context).setActiveIndex(2),
                ),
                AppBottomNavBarItem(
                  icon: AppIcons.profileSvg,
                  activeColor: context.appColors.neutrals1Color,
                  onTap: () => AutoTabsRouter.of(context).setActiveIndex(3),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppBottomNavBar extends BottomAppBar {
  const AppBottomNavBar({
    super.key,
    required this.items,
  });

  final List<AppBottomNavBarItem> items;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late final ValueNotifier<int> _activeIndexNotifier;
  late final TabsRouter _tabsRouter;

  @override
  void initState() {
    super.initState();
    _tabsRouter = AutoTabsRouter.of(context);
    _tabsRouter.addListener(_tabsListener);

    _activeIndexNotifier = ValueNotifier(_tabsRouter.activeIndex);
  }

  @override
  void dispose() {
    _activeIndexNotifier.dispose();
    _tabsRouter.removeListener(_tabsListener);
    super.dispose();
  }

  void _tabsListener() {
    if (_activeIndexNotifier.value != _tabsRouter.activeIndex) {
      _activeIndexNotifier.value = _tabsRouter.activeIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      padding: EdgeInsets.zero,
      height: 80,
      color: context.appColors.backgroundBase,
      child: Column(
        children: [
          Container(
            height: 1.2,
            color: context.appColors.secondary.shade50.withValues(alpha: 0.5),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ValueListenableBuilder(
                  valueListenable: _activeIndexNotifier,
                  builder: (context, index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < widget.items.length; i++)
                          AppBottomNavBarItem(
                            icon: widget.items[i].icon,
                            activeColor: widget.items[i].activeColor,
                            isActive: i == index,
                            onTap: widget.items[i].onTap,
                          )
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBottomNavBarItem extends StatelessWidget {
  const AppBottomNavBarItem({
    super.key,
    required this.icon,
    required this.activeColor,
    required this.onTap,
    this.isActive = false,
  });

  final String icon;
  final Color activeColor;
  final bool isActive;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SvgPicture.asset(
                  icon,
                  width: 24,
                  colorFilter:
                      ColorFilter.mode(isActive ? activeColor : context.appColors.neutrals5Color, BlendMode.srcIn),
                ),
              ),
              if (!isActive) const Gap(2),
              if (isActive)
                Center(
                  child: Container(
                    width: 7.5,
                    height: 7.5,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
