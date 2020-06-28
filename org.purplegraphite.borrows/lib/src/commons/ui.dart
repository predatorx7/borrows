import 'package:flutter/material.dart';

enum BrightnessMode {
  /// Light object, preferred on Dark backgrounds
  light,

  /// Dark object, preferred on Light backgrounds
  dark,

  /// Let parent widgets decide color (May use [Theme.of])
  auto,
}

// NOTE: Don't use getter when not debugging,
// It may cause the the application to do too much work on its main thread.
ThemeData get appTheme => ThemeData(
      primarySwatch: Colors.green,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.green.shade900,
            fontWeight: FontWeight.w700,
          ),
        ),
        color: Colors.transparent,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

ThemeData get appThemeDark => appTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
        color: Colors.transparent,
      ),
    );
