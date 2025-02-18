library;

import 'package:flutter/widgets.dart';

abstract class AppTextStyle {
  static const String? _fontPackage = null;
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
  static const TextStyle heading4 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle heading5 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle body1 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle body3 = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w400,
    package: _fontPackage,
  );
  static const TextStyle italic = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    package: _fontPackage,
  );
  static const TextStyle buttonXSmall = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 10,
    height: 1.5,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    package: _fontPackage,
  );
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w700,
    package: _fontPackage,
  );
}
