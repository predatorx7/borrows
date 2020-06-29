import 'package:flutter/material.dart';

import 'text/text.dart';

class PopupMenuTile extends PopupMenuEntry {
  final void Function() onTap;
  final Widget icon;
  final String label;
  final Widget child;
  PopupMenuTile({
    this.onTap,
    this.icon,
    this.label,
    this.child,
  });
  @override
  State<StatefulWidget> createState() => PopupMenuTileState();

  @override
  double get height => 45;

  @override
  bool represents(value) {
    return false;
  }
}

class PopupMenuTileState extends State<PopupMenuTile> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = popupMenuTheme.textStyle ?? theme.textTheme.subtitle1;

    if (widget.onTap == null)
      style = style.copyWith(color: theme.disabledColor);

    final bool isDark = theme.brightness == Brightness.dark;

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            widget.icon ?? SizedBox(),
            SizedBox(
              width: 15,
            ),
            (widget.label != null)
                ? TextBuilder(
                    context,
                    widget.label ?? '',
                    TextType.drawerText,
                    color: isDark ? Colors.white : Colors.black,
                  )
                : (widget.child ?? SizedBox()),
          ],
        ),
      ),
    );

    item = IconTheme.merge(
      data: IconThemeData(color: isDark ? Colors.white : Colors.black),
      child: item,
    );

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onTap();
      },
      canRequestFocus: widget.onTap != null,
      child: item,
    );
  }
}
