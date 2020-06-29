import 'package:flutter/widgets.dart';
import 'package:guidance_bubbles/src/_internal.dart';

import '../../guidance_bubbles.dart';

enum BubbleBehaviour {
  /// Bubble will only be shown one time on first launch
  firstLaunch,

  /// Bubble will be shown every time this widget is rebuilt
  everytime,

  /// Bubble will be shown only first time on every launch
  everyLaunch,
}

class GuidanceBubble extends StatelessWidget {
  /// Wraps this child and shows an instruction bubble for pointing it.
  final Widget child;

  /// To show counter text on bubble
  final bool showCounter;

  /// Show close button on bubble
  final bool showClose;

  /// Decides when this bubble will be shown
  final ShowBubble showBubble;

  /// Assign a unique identifier for this bubble. Required as there maybe more widgets
  /// wrapped with [this]
  final String uid;

  /// Create a widget wrapped with GuidanceBubble. This widget will be highlighted.
  GuidanceBubble(
      {Key key,
      this.child,
      this.showCounter,
      @required this.uid,
      this.showClose,
      this.showBubble})
      : super(key: key) {
    _setup();
  }

  void _setup() async {
    InternalPreferences internal = await InternalPreferences.getInstance();
    internal.uniqueBubbleBox.add(uid);
    final String whoHasFocus = internal.uniqueBubbleBox.whoHasFocus;
    if (whoHasFocus == null) {
      internal.uniqueBubbleBox.setFocus(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
