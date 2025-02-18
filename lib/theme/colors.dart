import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary50 = Color(0xffe6eff2);

  static const Color primary100 = Color(0xffb0ced8);

  static const Color primary200 = Color(0xff8ab6c5);

  static const Color primary300 = Color(0xff5595aa);

  static const Color primary400 = Color(0xff348199);

  static const Color primary500 = Color(0xff016180);

  static const Color primary600 = Color(0xff015874);

  static const Color primary700 = Color(0xff01455b);

  static const Color primary800 = Color(0xff013546);

  static const Color primary900 = Color(0xff002936);

  static const Color secondary50 = Color(0xffffefea);

  static const Color secondary100 = Color(0xfffeccbc);

  static const Color secondary200 = Color(0xfffdb49c);

  static const Color secondary300 = Color(0xfffc916f);

  static const Color secondary400 = Color(0xfffc7c53);

  static const Color secondary500 = Color(0xfffb5b28);

  static const Color secondary600 = Color(0xffe45324);

  static const Color secondary700 = Color(0xffb2411c);

  static const Color secondary800 = Color(0xff8a3216);

  static const Color secondary900 = Color(0xff692611);

  static const Color neutral50 = Color(0xfffdfdfc);

  static const Color neutral100 = Color(0xfff9f8f5);

  static const Color neutral200 = Color(0xfff6f4f1);

  static const Color neutral300 = Color(0xfff2efea);

  static const Color neutral400 = Color(0xffefece6);

  static const Color neutral500 = Color(0xffebe7e0);

  static const Color neutral600 = Color(0xffd6d2cc);

  static const Color neutral700 = Color(0xffa7a49f);

  static const Color neutral800 = Color(0xff817f7b);

  static const Color neutral900 = Color(0xff63615e);

  static const Color white50 = Color(0xffffffff);

  static const Color white100 = Color(0xfffdfdfd);

  static const Color white200 = Color(0xfffdfdfd);

  static const Color white300 = Color(0xfffcfcfc);

  static const Color white400 = Color(0xfffbfbfb);

  static const Color white500 = Color(0xfffafafa);

  static const Color white600 = Color(0xffe4e4e4);

  static const Color white700 = Color(0xffb2b2b2);

  static const Color white800 = Color(0xff8a8a8a);

  static const Color white900 = Color(0xff696969);

  static const Color black50 = Color(0xffeaeaea);

  static const Color black100 = Color(0xffbdbdbd);

  static const Color black200 = Color(0xff9d9d9d);

  static const Color black300 = Color(0xff717171);

  static const Color black400 = Color(0xff555555);

  static const Color black500 = Color(0xff2b2b2b);

  static const Color black600 = Color(0xff272727);

  static const Color black700 = Color(0xff1f1f1f);

  static const Color black800 = Color(0xff181818);

  static const Color black900 = Color(0xff121212);

  static const Color positive50 = Color(0xfff1fde9);

  static const Color positive100 = Color(0xffd5f8b9);

  static const Color positive200 = Color(0xffc0f498);

  static const Color positive300 = Color(0xffa4f068);

  static const Color positive400 = Color(0xff92ed4b);

  static const Color positive500 = Color(0xff77e81e);

  static const Color positive600 = Color(0xff6cd31b);

  static const Color positive700 = Color(0xff54a515);

  static const Color positive800 = Color(0xff418011);

  static const Color positive900 = Color(0xff32610d);

  static const Color error50 = Color(0xffffebe8);

  static const Color error100 = Color(0xfffec2b7);

  static const Color error200 = Color(0xfffea494);

  static const Color error300 = Color(0xfffe7a63);

  static const Color error400 = Color(0xfffd6145);

  static const Color error500 = Color(0xfffd3916);

  static const Color error600 = Color(0xffe63414);

  static const Color error700 = Color(0xffb42810);

  static const Color error800 = Color(0xff8b1f0c);

  static const Color error900 = Color(0xff6a1809);
}

MaterialColor primaryColor = MaterialColor(
  AppColors.primary500.value,
  const <int, Color>{
    50: AppColors.primary50,
    100: AppColors.primary100,
    200: AppColors.primary200,
    300: AppColors.primary300,
    400: AppColors.primary400,
    500: AppColors.primary500,
    600: AppColors.primary600,
    700: AppColors.primary700,
    800: AppColors.primary800,
    900: AppColors.primary900,
  },
);

MaterialColor secondaryColor = MaterialColor(
  AppColors.secondary500.value,
  <int, Color>{
    50: AppColors.secondary50,
    100: AppColors.secondary100,
    200: AppColors.secondary200,
    300: AppColors.secondary300,
    400: AppColors.secondary400,
    500: AppColors.secondary500,
    600: AppColors.secondary600,
    700: AppColors.secondary700,
    800: AppColors.secondary800,
    900: AppColors.secondary900,
  },
);

MaterialColor neutralColor = MaterialColor(
  AppColors.neutral500.value,
  <int, Color>{
    50: AppColors.neutral50,
    100: AppColors.neutral100,
    200: AppColors.neutral200,
    300: AppColors.neutral300,
    400: AppColors.neutral400,
    500: AppColors.neutral500,
    600: AppColors.neutral600,
    700: AppColors.neutral700,
    800: AppColors.neutral800,
    900: AppColors.neutral900,
  },
);

MaterialColor whiteColor = MaterialColor(
  AppColors.white500.value,
  <int, Color>{
    50: AppColors.white50,
    100: AppColors.white100,
    200: AppColors.white200,
    300: AppColors.white300,
    400: AppColors.white400,
    500: AppColors.white500,
    600: AppColors.white600,
    700: AppColors.white700,
    800: AppColors.white800,
    900: AppColors.white900,
  },
);

MaterialColor blackColor = MaterialColor(
  AppColors.black500.value,
  <int, Color>{
    50: AppColors.black50,
    100: AppColors.black100,
    200: AppColors.black200,
    300: AppColors.black300,
    400: AppColors.black400,
    500: AppColors.black500,
    600: AppColors.black600,
    700: AppColors.black700,
    800: AppColors.black800,
    900: AppColors.black900,
  },
);

MaterialColor errorColor = MaterialColor(
  AppColors.error500.value,
  <int, Color>{
    50: AppColors.error50,
    100: AppColors.error100,
    200: AppColors.error200,
    300: AppColors.error300,
    400: AppColors.error400,
    500: AppColors.error500,
    600: AppColors.error600,
    700: AppColors.error700,
    800: AppColors.error800,
    900: AppColors.error900,
  },
);

MaterialColor positiveColor = MaterialColor(
  AppColors.positive500.value,
  <int, Color>{
    50: AppColors.positive50,
    100: AppColors.positive100,
    200: AppColors.positive200,
    300: AppColors.positive300,
    400: AppColors.positive400,
    500: AppColors.positive500,
    600: AppColors.positive600,
    700: AppColors.positive700,
    800: AppColors.positive800,
    900: AppColors.positive900,
  },
);
