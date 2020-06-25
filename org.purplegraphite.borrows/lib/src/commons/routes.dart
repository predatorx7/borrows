import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Constant String screen's path address
import 'routing_const.dart';

// Screens

// Models

/// Wraps [screen] with a [PageRoute]
PageRoute<T> wrapPageRoute<T>(Widget screen,
    [bool useCupertinoPageRoute = true]) {
  if (useCupertinoPageRoute) {
    return CupertinoPageRoute<T>(builder: (context) => screen);
  }
  return MaterialPageRoute<T>(
    builder: (context) => screen,
  );
}

/// Generates Routes which will be used in the application
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RootRoute:
    default:
      // return wrapPageRoute<Root>(
      //   Root(
      //     key: RootRouteKey,
      //   ),
      // );
  }
}
