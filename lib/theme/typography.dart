library;

import 'package:flutter/widgets.dart';

abstract class AppTextStyle {
  static const String? _fontPackage = null;
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading4 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle heading5 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle body1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle body3 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle italic = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    package: _fontPackage,
  );
  static const TextStyle buttonXSmall = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
}
