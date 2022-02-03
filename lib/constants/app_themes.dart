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
    toggleableActiveColor: kGQuizAccent,
    cardTheme: base.cardTheme.copyWith(color: kGQuizWhiteBackground),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: kGQuizWhiteBackground),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      // backgroundColor: kGQuizBackgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Corners.xlRadius,
          topRight: Corners.xlRadius,
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: _gQuizLightColorScheme,
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
          fontSize: 25.0,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
        headline6: base.headline6.copyWith(
          fontFamily: 'Gilroy',
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1,
          color: Colors.white,
        ),
        subtitle1: base.subtitle1.copyWith(
          fontFamily: 'Gilroy',
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle2: base.subtitle2.copyWith(
          fontFamily: 'Gilroy',
          fontSize: 15.0,
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
          color: kGQuizAccent,
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
  secondary: kGQuizAccent,
  secondaryVariant: kGQuizAccent,
  surface: kGQuizWhiteBackground,
  error: kGQuizError,
  onError: kGQuizOnLightSurface,
);

