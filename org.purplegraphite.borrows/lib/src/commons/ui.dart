import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BrightnessMode {
  /// Light object, preferred on Dark backgrounds
  light,

  /// Dark object, preferred on Light backgrounds
  dark,

  /// Let parent widgets decide color (May use [Theme.of])
  auto,
}

class Corners {
  /// The border radius of Card & Material widgets in this application.
  ///
  /// The value is same as [BorderRadius.circular(25.0)].
  static const BorderRadius borderRadius =
      const BorderRadius.all(Radius.circular(25.0));
  static const ShapeBorder outlinedShapeBorder = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(25),
    ),
  );
}

// NOTE: Don't use getter when not debugging,
// It may cause the the application to do too much work on its main thread.
ThemeData get appTheme => ThemeData(
      primarySwatch: Colors.green,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          TextTheme(
            headline6: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.w700,
            ),
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
        textTheme: GoogleFonts.openSansTextTheme(
          TextTheme(
            headline6: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
