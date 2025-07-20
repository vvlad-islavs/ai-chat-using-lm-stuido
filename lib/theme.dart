import 'dart:developer';

import 'package:flutter/material.dart';

const robotoFontFamily = 'Roboto';

enum ThemeStyle {
  dark(name: 'Темная тема'),
  light(name: 'Светлая тема');

  final String name;

  const ThemeStyle({required this.name});

  ThemeData get theme {
    switch (this) {
      case ThemeStyle.dark:
        return _darkTheme;
      case ThemeStyle.light:
        // TODO: Реализация светлой темы, если когда-то будет.
        return _lightTheme;
    }
  }

  static ThemeStyle fromBrightness(Brightness brightness) => ThemeStyle.values[brightness.index];
}

extension AppThemeContext on BuildContext {
  /// Текущая тема приложения, обновляется реактивно.
  ThemeData get appTheme => Theme.of(this);

  /// Текущая тема текста приложения, обновляется реактивно.
  TextTheme get appTextTheme => Theme.of(this).textTheme;

  /// Текущая тема скроллбара приложения, обновляется реактивно.
  ScrollbarThemeData get appScrollbarTheme => Theme.of(this).scrollbarTheme;

  /// Цвета текущей темы приложения, обновляется реактивно.
  _AppColorsExtension get appColors => Theme.of(this).extension<_AppColorsExtension>()!;
}

final appThemeManager = AppThemeManager.instance;

class AppThemeManager extends ChangeNotifier {
  static late final AppThemeManager _instance;
  ThemeStyle _style = ThemeStyle.dark;

  /// Инициализация темы приложения.
  AppThemeManager.initialize({required Brightness brightness}) {
    _style = ThemeStyle.fromBrightness(brightness);
    _instance = this;

    log(_style.name, name: '$runtimeType');
  }

  static AppThemeManager get instance => _instance;

  /// Текущий стиль темы приложения.
  ThemeStyle get style => _style;

  /// Текущая тема приложения.
  ///
  /// Для использования вне context, не обновляется реактивно.
  ThemeData get appTheme => _style.theme;

  /// Текущая тема текста приложения.
  ///
  /// Для использования вне context, не обновляется реактивно.
  TextTheme get appTextTheme => _style.theme.textTheme;

  /// Текущая тема скроллбара приложения.
  ///
  /// Для использования вне context, не обновляется реактивно.
  ScrollbarThemeData get appScrollbarTheme => _style.theme.scrollbarTheme;

  /// Цвета текущей темы приложения.
  ///
  /// Для использования вне context, не обновляется реактивно.
  _AppColorsExtension get appColors => _style.theme.extension<_AppColorsExtension>()!;

  /// Устанавливает противоположную тему.
  void setInverseThemeStyle() {
    _style = _style == ThemeStyle.dark ? ThemeStyle.light : ThemeStyle.dark;
    log(_style.name, name: '$runtimeType');
    notifyListeners();
  }

  /// Устанавливает переданную тему - [style].
  void setThemeStyle({required ThemeStyle style}) {
    _style = style;
    notifyListeners();
  }
}

/// Main dark theme.
final _darkTheme = ThemeData(
  scaffoldBackgroundColor: _AppColors.backgroundBaseDark,
  useMaterial3: true,
  textTheme: _appTextTheme,
  scrollbarTheme: _appsScrollbarTheme,
  extensions: <ThemeExtension<_AppColorsExtension>>[
    const _AppColorsExtension(
      /// Цвет выделенной границы контейнера.
      enabledBorder: _AppColors.enabledBorder,

      /// Цвет не выделенной границы контейнера.
      disabledBorder: _AppColors.disabledBorder,

      /// Цвет scaffold темной темы.
      backgroundBaseDark: _AppColors.backgroundBaseDark,

      /// Цвет второстепенного фона темной темы, немного ярче чем scaffold и уходит немного в синие тона.
      backgroundSurfaceDark: _AppColors.backgroundSurfaceDark,

      /// Главная цветовая палитра приложения (синие тона)
      primary: MaterialColor(
        0xff4375FF,
        <int, Color>{
          25: Color(0xffF6F8FF),
          50: Color(0xffECF1FF),
          100: Color(0xffD9E3FF),
          200: Color(0xffB4C8FF),
          300: Color(0xff8EACFF),
          400: Color(0xff6991FF),
          500: Color(0xff4375FF),
          600: Color(0xff365ECC),
          700: Color(0xff284699),
          800: Color(0xff1B2F66),
          900: Color(0xff0D1733),
        },
      ),

      /// Второстепенная цветовая палитра приложения (серые тона)
      secondary: MaterialColor(
        0xff222426,
        <int, Color>{
          25: Color(0xffD0D2D9),
          50: Color(0xffBCBFC4),
          100: Color(0xffA8AAAF),
          200: Color(0xff6b6f78),
          300: Color(0xff505259),
          400: Color(0xff2D2F33),
          500: Color(0xff222426),
          600: Color(0xff1E2022),
          700: Color(0xff1A1B1D),
          800: Color(0xff161719),
          900: Color(0xff121314),
        },
      ),
    ),
  ],
);

/// Main light theme.
final _lightTheme = ThemeData(
  scaffoldBackgroundColor: _AppColors.grayAlias.shade300,
  useMaterial3: true,
  textTheme: _appTextTheme,
  scrollbarTheme: _appsScrollbarTheme,
  extensions: <ThemeExtension<_AppColorsExtension>>[
    _AppColorsExtension(
      enabledBorder: _AppColors.enabledBorder,
      disabledBorder: _AppColors.disabledBorder,
      backgroundBaseDark: _AppColors.backgroundBaseDark,
      backgroundSurfaceDark: _AppColors.backgroundSurfaceDark,

      /// Главная цветовая палитра приложения
      primary: const MaterialColor(
        0xff714CDE,
        <int, Color>{
          25: Color(0xffF8F5FD),
          50: Color(0xffF1ECFC),
          100: Color(0xffE3D9F8),
          200: Color(0xffC6B3F2),
          300: Color(0xffAA8EEB),
          400: Color(0xff8D68E5),
          500: Color(0xff714CDE),
          600: Color(0xff5A3DB2),
          700: Color(0xff442885),
          800: Color(0xff2D1A59),
          900: Color(0xff170D2C),
        },
      ),

      /// Второстепенная цветовая палитра приложения
      secondary: const MaterialColor(
        0xff222426,
        <int, Color>{
          25: Color(0xffD0D2D9),
          50: Color(0xffBCBFC4),
          100: Color(0xffA8AAAF),
          200: Color(0xff6b6f78),
          300: Color(0xff505259),
          400: Color(0xff2D2F33),
          500: Color(0xff222426),
          600: Color(0xff1E2022),
          700: Color(0xff1A1B1D),
          800: Color(0xff161719),
          900: Color(0xff121314),
        },
      ),
    ),
  ],
);

final _appsScrollbarTheme = ScrollbarThemeData(
  thumbColor: WidgetStateProperty.all(_AppColors.grayAlias.shade400),
  thickness: WidgetStateProperty.all(8),
  radius: const Radius.circular(8),
  interactive: true,
  trackVisibility: WidgetStateProperty.all(false),
  thumbVisibility: WidgetStateProperty.all(true),
  crossAxisMargin: 4,
);

final _appTextTheme = const TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w600,
    height: 1.25,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w600,
    height: 1.29,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w600,
    height: 1.29,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.40,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.16,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0.10,
  ),
  labelLarge: TextStyle(
    fontSize: 16,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0.40,
  ),
  labelMedium: TextStyle(
    fontSize: 14,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.10,
  ),
  labelSmall: TextStyle(
    fontSize: 12,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.40,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.30,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.24,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontFamily: robotoFontFamily,
    color: _AppColors.white,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.40,
  ),
);

class _AppColorsExtension extends ThemeExtension<_AppColorsExtension> {
  const _AppColorsExtension({
    required this.enabledBorder,
    required this.disabledBorder,
    required this.backgroundBaseDark,
    required this.backgroundSurfaceDark,
    required this.primary,
    required this.secondary,
  })  : transparent = _AppColors.transparent,
        white = _AppColors.white;

  final Color transparent;
  final Color white;
  final Color enabledBorder;
  final Color disabledBorder;
  final Color backgroundBaseDark;
  final Color backgroundSurfaceDark;

  final MaterialColor primary;
  final MaterialColor secondary;

  @override
  _AppColorsExtension copyWith({
    Color? enabledBorder,
    Color? disabledBorder,
    Color? backgroundBaseDark,
    Color? backgroundSurfaceDark,
    MaterialColor? primary,
    MaterialColor? secondary,
  }) =>
      _AppColorsExtension(
        enabledBorder: enabledBorder ?? this.enabledBorder,
        disabledBorder: disabledBorder ?? this.disabledBorder,
        backgroundBaseDark: backgroundBaseDark ?? this.backgroundBaseDark,
        backgroundSurfaceDark: backgroundSurfaceDark ?? this.backgroundSurfaceDark,
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
      );

  @override
  _AppColorsExtension lerp(ThemeExtension<_AppColorsExtension>? other, double t) {
    if (other is! _AppColorsExtension) {
      return this;
    }

    return _AppColorsExtension(
      enabledBorder: Color.lerp(enabledBorder, other.enabledBorder, t)!,
      disabledBorder: Color.lerp(disabledBorder, other.disabledBorder, t)!,
      backgroundBaseDark: Color.lerp(backgroundBaseDark, other.backgroundBaseDark, t)!,
      backgroundSurfaceDark: Color.lerp(backgroundSurfaceDark, other.backgroundSurfaceDark, t)!,
      primary: _lerpMaterialColor(primary, other.primary, t),
      secondary: _lerpMaterialColor(secondary, other.secondary, t),
    );
  }

  MaterialColor _lerpMaterialColor(MaterialColor a, MaterialColor b, double t) {
    final shades = <int>{
      ...a.keys,
      ...b.keys,
    };

    final Map<int, Color> lerpForShades = {
      for (var shade in shades) shade: Color.lerp(a[shade]!, b[shade]!, t)!,
    };

    final int baseValue = Color.lerp(Color(a.a.toInt()), Color(b.a.toInt()), t)!.a.toInt();

    return MaterialColor(baseValue, lerpForShades);
  }
}

/// Приватный класс-коллекция цветов приложения.
abstract final class _AppColors {
  static const transparent = Color(0x00000000);

  static const redAlias = MaterialColor(
    0xffFF435A,
    <int, Color>{
      25: Color(0xffFFF6F7),
      50: Color(0xffFFECEE),
      100: Color(0xffFFD9DE),
      200: Color(0xffFFB4BD),
      300: Color(0xffFF8E9C),
      400: Color(0xffFF697B),
      500: Color(0xffFF435A),
      600: Color(0xffCC3648),
      700: Color(0xff992836),
      800: Color(0xff661B24),
      900: Color(0xff330D12),
    },
  );

  static const yellowAlias = MaterialColor(
    0xffFFE433,
    <int, Color>{
      25: Color(0xffFFFEF5),
      50: Color(0xffFFFCEB),
      100: Color(0xffFFFAD6),
      200: Color(0xffFFF4AD),
      300: Color(0xffFFEF85),
      400: Color(0xffFFE95C),
      500: Color(0xffFFE433),
      600: Color(0xffCCB629),
      700: Color(0xff99891F),
      800: Color(0xff665B14),
      900: Color(0xff332E0A),
    },
  );

  static const greenAlias = MaterialColor(
    0xff41F6AA,
    <int, Color>{
      25: Color(0xffF5FFFB),
      50: Color(0xffECFEF6),
      100: Color(0xffD9FDEE),
      200: Color(0xffB3FBDD),
      300: Color(0xff8DFACC),
      400: Color(0xff67F8BB),
      500: Color(0xff41F6AA),
      600: Color(0xff34C588),
      700: Color(0xff279466),
      800: Color(0xff1A6244),
      900: Color(0xff0D3122),
    },
  );

  static const blueAlias = MaterialColor(
    0xff4375FF,
    <int, Color>{
      25: Color(0xffF6F8FF),
      50: Color(0xffECF1FF),
      100: Color(0xffD9E3FF),
      200: Color(0xffB4C8FF),
      300: Color(0xff8EACFF),
      400: Color(0xff6991FF),
      500: Color(0xff4375FF),
      600: Color(0xff365ECC),
      700: Color(0xff284699),
      800: Color(0xff1B2F66),
      900: Color(0xff0D1733),
    },
  );

  static const orangeAlias = MaterialColor(
    0xffFF5F2D,
    <int, Color>{
      25: Color(0xffFFF7F4),
      50: Color(0xffFFEFEA),
      100: Color(0xffFFDFD5),
      200: Color(0xffFFBFAB),
      300: Color(0xffFF9F81),
      400: Color(0xffFF7F57),
      500: Color(0xffFF5F2D),
      600: Color(0xffCC4C24),
      700: Color(0xff99391B),
      800: Color(0xff662612),
      900: Color(0xff331309),
    },
  );

  static const purpleAlias = MaterialColor(
    0xff714CDE,
    <int, Color>{
      25: Color(0xffF8F5FD),
      50: Color(0xffF1ECFC),
      100: Color(0xffE3D9F8),
      200: Color(0xffC6B3F2),
      300: Color(0xffAA8EEB),
      400: Color(0xff8D68E5),
      500: Color(0xff714CDE),
      600: Color(0xff5A3DB2),
      700: Color(0xff442885),
      800: Color(0xff2D1A59),
      900: Color(0xff170D2C),
    },
  );

  static const grayAlias = MaterialColor(
    0xff222426,
    <int, Color>{
      25: Color(0xffD0D2D9),
      50: Color(0xffBCBFC4),
      100: Color(0xffA8AAAF),
      200: Color(0xff6b6f78),
      300: Color(0xff505259),
      400: Color(0xff2D2F33),
      500: Color(0xff222426),
      600: Color(0xff1E2022),
      700: Color(0xff1A1B1D),
      800: Color(0xff161719),
      900: Color(0xff121314),
    },
  );

  /// Стандартный белый цвет.
  static const white = Color(0xffffffff);

  /// Цвет выделенной границы контейнера.
  static const enabledBorder = Color(0xff4372b5);

  /// Цвет не выделенной границы контейнера.
  static const disabledBorder = Color(0xff616f7a);

  /// Цвет scaffold темной темы.
  static const backgroundBaseDark = Color(0xff06060a);

  /// Цвет второстепенного фона темной темы, немного ярче чем scaffold и уходит немного в синие тона.
  static const backgroundSurfaceDark = Color(0xff0d1318);
}
