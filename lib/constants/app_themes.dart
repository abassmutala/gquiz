import 'package:flutter/material.dart';
import 'package:gquiz/constants/app_colors.dart';
import 'package:gquiz/constants/constants.dart';

final ThemeData gQuizLightTheme = _gQuizLightTheme();

ThemeData _gQuizLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _gQuizLightTextTheme(base.textTheme),
    // scaffoldBackgroundColor: kGQuizScaffoldBackground,
    appBarTheme: base.appBarTheme.copyWith(
      // color: kGQuizWhiteBackground,
      // iconTheme: const IconThemeData(color: kGQuizOnLightSurface),
      // foregroundColor: kGQuizOnLightSurface,
    ),
    textSelectionTheme: TextSelectionThemeData(selectionColor: base.colorScheme.primary.withOpacity(0.25)),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelStyle: base.textTheme.bodyText1.copyWith(fontFamily: 'Gilroy'),
      labelColor: base.textTheme.bodyText1.color,
      unselectedLabelColor: base.textTheme.bodyText1.color.withOpacity(0.7),
      unselectedLabelStyle: base.textTheme.bodyText1.copyWith(
        fontFamily: 'Gilroy',
        // color: kGQuizDisabledFlatButton,
      ),
    ),
    sliderTheme: base.sliderTheme.copyWith(
      trackHeight: 1.0,
      // thumbColor: kGQuizLightAccent,
      // activeTrackColor: kGQuizLightAccent,
    ),
    iconTheme: base.iconTheme.copyWith(color: kGQuizOnLightSurface),
    toggleableActiveColor: kGQuizLightAccent,
    cardTheme: base.cardTheme.copyWith(color: kGQuizWhiteBackground),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: kGQuizPrimary,
        selectedIconTheme: base.iconTheme.copyWith(color: kGQuizLightAccent),
        ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: kGQuizWhiteBackground),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      // backgroundColor: kGQuizBackgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Corners.xxlRadius,
          topRight: Corners.xxlRadius,
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: _gQuizLightColorScheme,
//cupertinoOverrideTheme: const NoDefaultCupertinoThemeData() TODO
    // primaryIconTheme: _customIconTheme(base.iconTheme),
    // inputDecorationTheme: const InputDecorationTheme(border: CutCornersBorder()),
    // textTheme: _buildShrineTextTheme(base.textTheme),
    // primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    // accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    // iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _gQuizLightTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline3: base.headline3.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 35.0,
          // fontWeight: FontWeight.w400,
          // letterSpacing: 0.25,
        ),
        headline4: base.headline4.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 35.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headline5: base.headline5.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 20.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle1: base.subtitle1.copyWith(
          fontFamily: 'Gilroy',
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle2: base.subtitle2.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyText1: base.bodyText1.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyText2: base.bodyText1.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        button: base.button.copyWith(
          fontFamily: 'Gilroy',
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
          color: kGQuizLightAccent,
        ),
        caption: base.caption.copyWith(
          fontFamily: 'Gilroy',
          // fontSize: 13.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
      )
      .apply(bodyColor: kGQuizOnLightSurface);
}

ColorScheme _gQuizLightColorScheme = const ColorScheme.light().copyWith(
  primary: kGQuizPrimary,
  primaryVariant: kGQuizPrimaryVariant,
  secondary: kGQuizLightAccent,
  secondaryVariant: kGQuizLightAccent,
  surface: kGQuizWhiteBackground,
  error: kGQuizError,
  onError: kGQuizOnLightSurface,
);

