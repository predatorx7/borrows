import 'package:guidance_bubbles/guidance_bubbles.dart';
import 'package:flutter/material.dart';

/// First plugin test method.
void main() => runApp(_BubbleShowcaseDemoApp());

/// The demo material app.
class _BubbleShowcaseDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Bubble Showcase Demo',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Bubble Showcase Demo'),
          ),
          body: HomeScreen(),
        ),
      );
}

/// The main demo widget.
class HomeScreen extends StatelessWidget {
  /// The title text global key.
  final GlobalKey _titleKey = GlobalKey();

  /// The first button global key.
  final GlobalKey _firstButtonKey = GlobalKey();

  /// Creates the first slide.
  BubbleSlide _firstSlide(TextStyle textStyle) => RelativeBubbleSlide(
        key: _titleKey,
        child: RelativeBubbleSlideChild(
          widget: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SpeechBubble(
              nipLocation: NipLocation.TOP,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'That\'s cool !',
                      style: textStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'This is my brand new title !',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  /// Creates the second slide.
  BubbleSlide _secondSlide(TextStyle textStyle) => AbsoluteBubbleSlide(
        positionCalculator: (size) => Position(
          top: 0,
          right: 0,
          left: 0,
          bottom: size.height,
        ),
        child: RelativeBubbleSlideChild(
          widget: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SpeechBubble(
              nipLocation: NipLocation.LEFT,
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Look at me pointing absolutely nothing.\n(Or maybe that\'s an hidden navigation bar !)',
                  style: textStyle,
                ),
              ),
            ),
          ),
          direction: AxisDirection.left,
        ),
      );

  /// Creates the third slide.
  BubbleSlide _thirdSlide(TextStyle textStyle) => RelativeBubbleSlide(
        key: _firstButtonKey,
        shape: const Oval(
          spreadRadius: 15,
        ),
        child: RelativeBubbleSlideChild(
          widget: Padding(
            padding: const EdgeInsets.only(top: 23),
            child: SpeechBubble(
              nipLocation: NipLocation.TOP,
              color: Colors.purple,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'As said, this button is new.\nOh, and this one is oval by the way.',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          color: Colors.white,
        );
    return BubbleShowcase(
      showBubble: ShowBubble.everyTime,
      bubbleSlides: [
        _firstSlide(textStyle),
        _secondSlide(textStyle),
        _thirdSlide(textStyle),
      ],
      child: HomeScreenBody(_titleKey, _firstButtonKey),
    );
  }
}

/// The main demo widget child.
class HomeScreenBody extends StatelessWidget {
  /// The title text global key.
  final GlobalKey _titleKey;

  /// The first button global key.
  final GlobalKey _firstButtonKey;

  /// Creates a new bubble showcase demo child instance.
  HomeScreenBody(this._titleKey, this._firstButtonKey);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Bubble Showcase',
                key: _titleKey,
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: RaisedButton(
                child: const Text('This button is NEW !'),
                key: _firstButtonKey,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                },
              ),
            ),
            RaisedButton(
              child: const Text(
                  'This button is old, please don\'t pay attention.'),
              onPressed: () {},
            )
          ],
        ),
      );
}
