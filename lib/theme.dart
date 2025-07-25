import 'dart:developer';

import 'package:flutter/material.dart';

const poppinsFontFamily = 'Poppins';
const urbanistFontFamily = 'Urbanist';

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

//
//
// Расширение темы для доступа в context, обновляется реактивно.
//
//
extension AppThemeContext on BuildContext {
  /// Текущая тема приложения, обновляется реактивно.
  ThemeData get appTheme => Theme.of(this);

  /// Текущая тема текста приложения со шрифтом 'Poppins'.
  ///
  /// Обновляется реактивно.
  TextTheme get appPoppinsTextTheme => Theme.of(this).extension<_AppPoppinsExtension>()!.textTheme;

  /// Текущая тема текста приложения со шрифтом 'Urbanist'.
  ///
  /// Обновляется реактивно.
  TextTheme get appUrbanistTextTheme => Theme.of(this).extension<_AppUrbanistExtension>()!.textTheme;

  /// Текущая тема скроллбара приложения, обновляется реактивно.
  ScrollbarThemeData get appScrollbarTheme => Theme.of(this).scrollbarTheme;

  /// Цвета текущей темы приложения, обновляется реактивно.
  _AppColorsExtension get appColors => Theme.of(this).extension<_AppColorsExtension>()!;
}

final appThemeManager = AppThemeManager.instance;

//
//
// Менеджер темы для доступа вне context, не обновляется реактивно.
//
//
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

  /// Текущая тема текста приложения со шрифтом 'Poppins'.
  ///
  /// Для использования вне context, не обновляется реактивно.
  TextTheme get appPoppinsTextTheme => _style.theme.extension<_AppPoppinsExtension>()!.textTheme;

  /// Текущая тема текста приложения со шрифтом 'Urbanist'.
  ///
  /// Для использования вне context, не обновляется реактивно.
  TextTheme get appUrbanistTextTheme => _style.theme.extension<_AppUrbanistExtension>()!.textTheme;

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

//
//
// Темная тема приложения
//
//
/// Main dark theme.
final _darkTheme = ThemeData(
  scaffoldBackgroundColor: _AppColors.backgroundBaseDark,
  useMaterial3: true,
  scrollbarTheme: _appsScrollbarTheme,
  extensions: <ThemeExtension<dynamic>>[
    _AppPoppinsExtension(textTheme: _poppinsTextTheme),
    _AppUrbanistExtension(textTheme: _urbanistTextTheme),
    const _AppColorsExtension(
      /// Цвет выделенной границы контейнера.
      enabledBorder: _AppColors.enabledBorder,

      /// Цвет не выделенной границы контейнера.
      disabledBorder: _AppColors.disabledBorder,

      /// Цвет scaffold темной темы.
      backgroundBase: _AppColors.backgroundBaseDark,

      /// Цвет второстепенного фона темной темы, немного ярче чем scaffold и уходит немного в синие тона.
      backgroundSurface: _AppColors.backgroundSurfaceDark,

      contrastComponentsColor: _AppColors.lightComponentsColor,
      componentsColor: _AppColors.backgroundSurfaceDark,
      secondaryButtonBackground: _AppColors.lightSecondaryButtonBackground,
      secondaryButtonText: _AppColors.lightSecondaryButtonText,
      logInShadow: _AppColors.lightLogInShadow,
      neutrals1Color: _AppColors.lightNeutrals1,
      neutrals2Color: _AppColors.lightNeutrals2,
      neutrals5Color: _AppColors.lightNeutrals5,
      neutrals6Color: _AppColors.lightNeutrals6,

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

//
//
// Светлая тема приложения
//
//
/// Main light theme.
final _lightTheme = ThemeData(
  scaffoldBackgroundColor: _AppColors.backgroundBaseLight,
  useMaterial3: true,
  scrollbarTheme: _appsScrollbarTheme,
  extensions: <ThemeExtension<dynamic>>[
    _AppPoppinsExtension(textTheme: _poppinsTextTheme),
    _AppUrbanistExtension(textTheme: _urbanistTextTheme),
    const _AppColorsExtension(
      enabledBorder: _AppColors.enabledBorder,
      disabledBorder: _AppColors.disabledBorder,
      backgroundBase: _AppColors.backgroundBaseLight,
      backgroundSurface: _AppColors.backgroundSurfaceDark,
      contrastComponentsColor: _AppColors.lightContrastComponentsColor,
      componentsColor: _AppColors.lightComponentsColor,
      secondaryButtonBackground: _AppColors.lightSecondaryButtonBackground,
      secondaryButtonText: _AppColors.lightSecondaryButtonText,
      logInShadow: _AppColors.lightLogInShadow,
      neutrals1Color: _AppColors.lightNeutrals1,
      neutrals2Color: _AppColors.lightNeutrals2,
      neutrals5Color: _AppColors.lightNeutrals5,
      neutrals6Color: _AppColors.lightNeutrals6,

      /// Главная цветовая палитра приложения
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

//
//
// Параметры скроллбара приложения
//
//
final _appsScrollbarTheme = ScrollbarThemeData(
  thumbColor: WidgetStateProperty.all(_AppColors.grayAlias.shade400),
  thickness: WidgetStateProperty.all(8),
  radius: const Radius.circular(8),
  interactive: true,
  trackVisibility: WidgetStateProperty.all(false),
  thumbVisibility: WidgetStateProperty.all(true),
  crossAxisMargin: 4,
);

//
//
// Параметры текста со шрифтом Poppins
//
//
final _poppinsTextTheme = const TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
  ),

  /// bold 34 headlineSmall
  headlineSmall: TextStyle(
    fontSize: 34,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: 0,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.40,
    letterSpacing: 0,
  ),

  /// semiBold 20 titleMedium
  titleMedium: TextStyle(
    fontSize: 20,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  ),
  labelLarge: TextStyle(
    fontSize: 16,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0,
  ),

  /// SemiBold 16 labelMedium
  labelMedium: TextStyle(
    fontSize: 16,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0,
  ),

  /// medium 14 labelSmall
  labelSmall: TextStyle(
    fontSize: 14,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0,
  ),

  /// Regular 14 bodyMedium
  bodyMedium: TextStyle(
    fontSize: 14,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
  ),

  /// Light 14 bodySmall
  bodySmall: TextStyle(
    fontSize: 12,
    fontFamily: poppinsFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w300,
    height: 1.33,
    letterSpacing: 0,
  ),
);

//
//
// Параметры текста со шрифтом Urbanist
//
//
final _urbanistTextTheme = const TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
  ),

  /// bold 34 headlineSmall
  headlineSmall: TextStyle(
    fontSize: 34,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: 0,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.40,
    letterSpacing: 0,
  ),

  /// semiBold 20 titleMedium
  titleMedium: TextStyle(
    fontSize: 20,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  ),
  labelLarge: TextStyle(
    fontSize: 16,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.50,
    letterSpacing: 0,
  ),

  /// SemiBold 16 labelMedium
  labelMedium: TextStyle(
    fontSize: 16,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0,
  ),

  /// medium 14 labelSmall
  labelSmall: TextStyle(
    fontSize: 14,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0,
  ),

  /// Regular 14 bodyMedium
  bodyMedium: TextStyle(
    fontSize: 14,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
  ),

  /// Light 14 bodySmall
  bodySmall: TextStyle(
    fontSize: 12,
    fontFamily: urbanistFontFamily,
    color: _AppColors.darkTextColor,
    fontWeight: FontWeight.w300,
    height: 1.33,
    letterSpacing: 0,
  ),
);

//
//
//Расширение текста Urbanist для ThemeData
//
//
class _AppPoppinsExtension extends ThemeExtension<_AppPoppinsExtension> {
  const _AppPoppinsExtension({
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  ThemeExtension<_AppPoppinsExtension> copyWith({TextTheme? textTheme}) => _AppPoppinsExtension(
        textTheme: textTheme ?? this.textTheme,
      );

  @override
  ThemeExtension<_AppPoppinsExtension> lerp(covariant ThemeExtension<_AppPoppinsExtension>? other, double t) {
    if (other is! _AppPoppinsExtension) {
      return this;
    }

    return _AppPoppinsExtension(textTheme: TextTheme.lerp(textTheme, other.textTheme, t));
  }
}

//
//
//Расширение текста Poppins для ThemeData
//
//
class _AppUrbanistExtension extends ThemeExtension<_AppUrbanistExtension> {
  const _AppUrbanistExtension({
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  ThemeExtension<_AppUrbanistExtension> copyWith({TextTheme? textTheme}) => _AppUrbanistExtension(
        textTheme: textTheme ?? this.textTheme,
      );

  @override
  ThemeExtension<_AppUrbanistExtension> lerp(covariant ThemeExtension<_AppUrbanistExtension>? other, double t) {
    if (other is! _AppUrbanistExtension) {
      return this;
    }

    return _AppUrbanistExtension(textTheme: TextTheme.lerp(textTheme, other.textTheme, t));
  }
}

//
//
// Расширениe цветов для ThemeData
//
//
class _AppColorsExtension extends ThemeExtension<_AppColorsExtension> {
  const _AppColorsExtension({
    required this.enabledBorder,
    required this.disabledBorder,
    required this.backgroundBase,
    required this.backgroundSurface,
    required this.contrastComponentsColor,
    required this.componentsColor,
    required this.secondaryButtonBackground,
    required this.secondaryButtonText,
    required this.logInShadow,
    required this.neutrals1Color,
    required this.neutrals2Color,
    required this.neutrals5Color,
    required this.neutrals6Color,
    required this.primary,
    required this.secondary,
  })  : transparent = _AppColors.transparent,
        white = _AppColors.white,
        googleLogIn = _AppColors.googleLogIn,
        facebookLogIn = _AppColors.facebookLogIn;

  final Color transparent;
  final Color white;
  final Color googleLogIn;
  final Color facebookLogIn;
  final Color enabledBorder;
  final Color disabledBorder;
  final Color backgroundBase;
  final Color contrastComponentsColor;
  final Color componentsColor;
  final Color secondaryButtonBackground;
  final Color secondaryButtonText;
  final Color logInShadow;
  final Color neutrals1Color;
  final Color neutrals2Color;
  final Color neutrals5Color;
  final Color neutrals6Color;
  final Color backgroundSurface;

  final MaterialColor primary;
  final MaterialColor secondary;

  @override
  _AppColorsExtension copyWith({
    Color? enabledBorder,
    Color? disabledBorder,
    Color? backgroundBaseDark,
    Color? backgroundSurfaceDark,
    Color? contrastComponentsColor,
    Color? componentsColor,
    Color? secondaryButtonBackground,
    Color? secondaryButtonText,
    Color? logInShadow,
    Color? neutrals1Color,
    Color? neutrals2Color,
    Color? neutrals5Color,
    Color? neutrals6Color,
    MaterialColor? primary,
    MaterialColor? secondary,
  }) =>
      _AppColorsExtension(
        enabledBorder: enabledBorder ?? this.enabledBorder,
        disabledBorder: disabledBorder ?? this.disabledBorder,
        backgroundBase: backgroundBaseDark ?? this.backgroundBase,
        backgroundSurface: backgroundSurfaceDark ?? this.backgroundSurface,
        contrastComponentsColor: contrastComponentsColor ?? this.contrastComponentsColor,
        componentsColor: componentsColor ?? this.componentsColor,
        secondaryButtonBackground: secondaryButtonBackground ?? this.secondaryButtonBackground,
        secondaryButtonText: secondaryButtonText ?? this.secondaryButtonText,
        logInShadow: logInShadow ?? this.logInShadow,
        neutrals1Color: neutrals1Color ?? this.neutrals1Color,
        neutrals2Color: neutrals2Color ?? this.neutrals2Color,
        neutrals5Color: neutrals5Color ?? this.neutrals5Color,
        neutrals6Color: neutrals6Color ?? this.neutrals6Color,
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
      backgroundBase: Color.lerp(backgroundBase, other.backgroundBase, t)!,
      backgroundSurface: Color.lerp(backgroundSurface, other.backgroundSurface, t)!,
      contrastComponentsColor: Color.lerp(contrastComponentsColor, other.contrastComponentsColor, t)!,
      componentsColor: Color.lerp(componentsColor, other.componentsColor, t)!,
      secondaryButtonBackground: Color.lerp(secondaryButtonBackground, other.secondaryButtonBackground, t)!,
      secondaryButtonText: Color.lerp(secondaryButtonText, other.secondaryButtonText, t)!,
      logInShadow: Color.lerp(logInShadow, other.logInShadow, t)!,
      neutrals1Color: Color.lerp(neutrals1Color, other.neutrals1Color, t)!,
      neutrals2Color: Color.lerp(neutrals2Color, other.neutrals2Color, t)!,
      neutrals5Color: Color.lerp(neutrals5Color, other.neutrals5Color, t)!,
      neutrals6Color: Color.lerp(neutrals6Color, other.neutrals6Color, t)!,
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

//
//
// Общий класс-коллекция для хранения всех цветов приложения.
//
//
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
  static const darkTextColor = Color(0xff121212);

  static const lightContrastComponentsColor = Color(0xff141718);
  static const lightComponentsColor = Color(0xffFCFCFD);

  static const lightNeutrals1 = Color(0xff141416);
  static const lightNeutrals2 = Color(0xff23262F);
  static const lightNeutrals5 = Color(0xffB1B5C3);
  static const lightNeutrals6 = Color(0xffE6E8EC);

  static const lightSecondaryButtonBackground = Color(0xffE3E3E3);
  static const lightSecondaryButtonText = Color(0xffB1B1B1);
  static const lightLogInShadow = Color(0xff17CE92);

  static const googleLogIn = Color(0xffD44638);
  static const facebookLogIn = Color(0xff4267B2);

  /// Цвет выделенной границы контейнера.
  static const enabledBorder = Color(0xff4372b5);

  /// Цвет не выделенной границы контейнера.
  static const disabledBorder = Color(0xff616f7a);

  /// Цвет scaffold темной темы.
  static const backgroundBaseDark = Color(0xff06060a);

  static const backgroundBaseLight = Color(0xffF7F8FA);

  /// Цвет второстепенного фона темной темы, немного ярче чем scaffold и уходит немного в синие тона.
  static const backgroundSurfaceDark = Color(0xff0d1318);
}
