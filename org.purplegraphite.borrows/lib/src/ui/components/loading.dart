import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final bool useScaffold;
  final bool useWhiteBackground;
  const CircularLoading({
    Key key,
    this.useScaffold = true,
    this.useWhiteBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
    if (useScaffold) {
      child = Scaffold(body: child);
    } else if (useWhiteBackground) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: child,
      );
    }
    return Theme(
      data: ThemeData(
        accentColor: Colors.lightGreenAccent,
        backgroundColor: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.yellow,
      ),
      child: child,
    );
  }
}
