import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/theme/typography.dart';

ThemeData buildTheme(Brightness brightness, ThemeProvider provider) {
  return ThemeData(
    splashColor: primaryColor.shade100,
    shadowColor: primaryColor.withValues(alpha: 0.2),
    cardTheme: CardTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: primaryColor.withValues(alpha: 0.2),
    ),
    useMaterial3: true,
    colorScheme:
        provider.useSeedColor
            ? ColorScheme.fromSeed(
              seedColor: provider.seedColor,
              brightness: brightness,
            )
            : ColorScheme.fromSwatch(
              accentColor: secondaryColor,
              brightness: brightness,
            ).copyWith(primary: primaryColor, secondary: secondaryColor),
    fontFamily: 'PlusJakartaSans',
    textTheme: const TextTheme(
      displayLarge: AppTextStyle.heading1,
      displayMedium: AppTextStyle.heading1,
      displaySmall: AppTextStyle.heading2,
      headlineLarge: AppTextStyle.heading3,
      headlineMedium: AppTextStyle.heading4,
      headlineSmall: AppTextStyle.heading5,
      titleLarge: AppTextStyle.heading1,
      titleMedium: AppTextStyle.buttonLarge,
      titleSmall: AppTextStyle.buttonMedium,
      labelLarge: AppTextStyle.buttonSmall,
      labelMedium: AppTextStyle.buttonXSmall,
      labelSmall: AppTextStyle.italic,
      bodyLarge: AppTextStyle.body1,
      bodyMedium: AppTextStyle.body2,
      bodySmall: AppTextStyle.body3,
    ),
  );
}
