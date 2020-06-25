import 'package:flutter/foundation.dart' show ValueKey;

const String RootRoute = "/";

// Here, the value of this key below is compared when widgets are refreshed. If the value matches
// with an existing key in the widget tree, then the widget updates instead of remounting.
const ValueKey<String> RootRouteKey = const ValueKey<String>('rootScreen');
