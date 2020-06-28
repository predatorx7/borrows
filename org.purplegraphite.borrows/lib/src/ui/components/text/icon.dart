import 'package:flutter/material.dart';
import '../../../commons/ui.dart';

/// The icon style this application will use
enum IconType {
  drawerIcon,
}

class IconBuilder extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color color;
  final String semanticLabel;

  const IconBuilder._(this.iconData, this.size, this.color,
      {Key key, this.semanticLabel})
      : super(key: key);

  static Color _createEffectiveColor(
      BuildContext context, bool beDark, Color defaultColor) {
    defaultColor ??= Theme.of(context).iconTheme.color ??
        (beDark ? Colors.black : Colors.white);
    return defaultColor;
  }

  factory IconBuilder(
      BuildContext context, IconData iconData, IconType iconType,
      {Key key,
      double size,
      Color color,
      String semanticLabel,
      BrightnessMode iconBrightness}) {
    Color _effectiveColor;
    bool beDark;
    switch (iconBrightness) {
      case BrightnessMode.light:
        beDark = false;
        break;
      case BrightnessMode.dark:
        beDark = true;
        break;
      case BrightnessMode.auto:
      default:
        // Application brightness
        final Brightness brightness = Theme.of(context).brightness;
        beDark = brightness == Brightness.dark;
        break;
    }
    switch (iconType) {
      case IconType.drawerIcon:
        _effectiveColor = _createEffectiveColor(context, beDark, color);
        size ??= 22;
        break;
    }
    return IconBuilder._(iconData, size, _effectiveColor,
        semanticLabel: semanticLabel, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
