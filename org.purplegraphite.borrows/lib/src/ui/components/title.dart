import 'package:borrows/src/commons/string_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationTitle extends StatelessWidget {
  static TextStyle _style = GoogleFonts.bitter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      Strings.applicationTitle,
      style: _style.apply(
        color: isDark ? Colors.green.shade900 : Colors.green,
      ),
    );
  }
}
