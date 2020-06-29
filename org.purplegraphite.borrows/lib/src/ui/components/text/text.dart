import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/ui.dart';

/// The text style this application will use
enum TextType {
  drawerText,
  appbarText,
}

/// The text tyle material design in 2018 follows
enum MaterialTextType {
  /// Extremely large text.
  headline1,

  /// Very, very large text.
  ///
  /// Used for the date in the dialog shown by [showDatePicker].
  headline2,

  /// Very large text.
  headline3,

  /// Large text.
  headline4,

  /// Used for large text in dialogs (e.g., the month and year in the dialog
  /// shown by [showDatePicker]).
  headline5,

  /// Used for the primary text in app bars and dialogs (e.g., [AppBar.title]
  /// and [AlertDialog.title]).
  headline6,

  /// Used for the primary text in lists (e.g., [ListTile.title]).
  subtitle1,

  /// For medium emphasis text that's a little smaller than [subtitle1].
  subtitle2,

  /// Used for emphasizing text that would otherwise be [bodyText2].
  bodyText1,

  /// The default text style for [Material].
  bodyText2,

  /// Used for auxiliary text associated with images.
  caption,

  /// Used for text on [RaisedButton] and [FlatButton].
  button,

  /// The smallest style.
  ///
  /// Typically used for captions or to introduce a (larger) headline.
  overline,
}

class TextBuilder extends StatelessWidget {
  final TextStyle textStyle;
  final String text;
  static final _textStyle = GoogleFonts.openSans();

  TextBuilder._(this.text, this.textStyle);

  factory TextBuilder(
    BuildContext context,
    String text,
    TextType textType, {
    Color color,
    TextStyle style,
    BrightnessMode textBrightness = BrightnessMode.auto,
  }) {
    TextStyle textStyle;
    // should text be dark?
    bool beDark;

    // Determine text brightness
    switch (textBrightness) {
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

    // Determine text color
    final Color textColor = beDark ? Colors.black : Colors.white;

    textStyle = (style != null) ? style : _textStyle;

    // Change theme based on situation
    switch (textType) {
      case TextType.drawerText:
        final Color _color =
            (textBrightness == BrightnessMode.auto) ? Colors.black : textColor;
        textStyle = textStyle.copyWith(
          fontSize: 11,
          color: color ?? _color,
          fontWeight: FontWeight.w600,
        );
        break;
      case TextType.appbarText:
        Color _color;
        if (color != null) {
          _color = color;
        } else {
          _color = (textBrightness == BrightnessMode.auto)
              ? Colors.black
              : textColor;
        }
        textStyle = textStyle.copyWith(
          fontSize: 16,
          color: color ?? _color,
          fontWeight: FontWeight.w900,
        );
        break;
      default:
        final Color _color =
            (textBrightness == BrightnessMode.auto) ? Colors.black : textColor;
        textStyle = _textStyle.copyWith(
          fontSize: 14,
          color: color ?? _color,
          fontWeight: FontWeight.normal,
        );
        break;
    }
    return TextBuilder._(text, textStyle);
  }

  /// Build Text to follow material design
  factory TextBuilder.material(
      BuildContext context, String text, MaterialTextType theme,
      {Color color, TextStyle style}) {
    TextStyle _textStyle;
    switch (theme) {
      case MaterialTextType.headline1:
        _textStyle = Theme.of(context).textTheme.headline1;
        break;
      case MaterialTextType.headline2:
        _textStyle = Theme.of(context).textTheme.headline2;
        break;
      case MaterialTextType.headline3:
        _textStyle = Theme.of(context).textTheme.headline3;
        break;
      case MaterialTextType.headline4:
        _textStyle = Theme.of(context).textTheme.headline4;
        break;
      case MaterialTextType.headline5:
        _textStyle = Theme.of(context).textTheme.headline5;
        break;
      case MaterialTextType.headline6:
        _textStyle = Theme.of(context).textTheme.headline6;
        break;
      case MaterialTextType.subtitle1:
        _textStyle = Theme.of(context).textTheme.subtitle1;
        break;
      case MaterialTextType.subtitle2:
        _textStyle = Theme.of(context).textTheme.subtitle2;
        break;
      case MaterialTextType.bodyText1:
        _textStyle = Theme.of(context).textTheme.bodyText1;
        break;
      case MaterialTextType.bodyText2:
        _textStyle = Theme.of(context).textTheme.bodyText2;
        break;
      case MaterialTextType.caption:
        _textStyle = Theme.of(context).textTheme.caption;
        break;
      case MaterialTextType.button:
        _textStyle = Theme.of(context).textTheme.button;
        break;
      case MaterialTextType.overline:
        _textStyle = Theme.of(context).textTheme.overline;
        break;
    }
    final TextStyle effectiveStyle = (style == null)
        ? _textStyle.apply(color: color ?? _textStyle.color)
        : _textStyle.merge(style).apply(color: color ?? style.color);
    return TextBuilder._(text, effectiveStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, style: textStyle);
  }
}
