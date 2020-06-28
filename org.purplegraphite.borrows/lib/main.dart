import 'package:borrows/src/commons/routes.dart';
import 'package:borrows/src/utils/string_util.dart';
import 'package:flutter/material.dart';

import 'src/commons/string_const.dart';
import 'src/commons/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringUtils.toFirstLetterUppercase(Strings.applicationTitle),
      theme: appTheme,
      // TODO: Test brightness in release/profile mode, if switching system brightness turns glitchy then only create a bug issue in flutter
      darkTheme: appThemeDark,
      onGenerateRoute: generateRoute,
    );
  }
}
