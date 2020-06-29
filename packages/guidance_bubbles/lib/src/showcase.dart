library bubble_showcase;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:guidance_bubbles/src/_internal.dart';
import 'slide.dart';

enum ShowBubble { onlyForFirstLaunch, everyTime, everyLaunch }

class CounterText {
  int _currentSlide;

  int get currentSlide => _currentSlide;

  int _slideCounts;

  int get slideCounts => _slideCounts;

  /// TO show a counter text, it should have current slide & slides count.
  CounterText(int currentSlide, int slideCounts)
      : assert(currentSlide != null),
        assert(slideCounts != null),
        assert(currentSlide <= slideCounts,
            'CurrentSlide cannot be more than slideCount'),
        assert(slideCounts > 1, 'Slide counts cannot be less than 1'),
        _currentSlide = currentSlide,
        _slideCounts = slideCounts;

  void setCurrentSlide(int i) {
    _currentSlide = i;
  }

  void setSlideCount(int c) {
    _slideCounts = c;
  }

  String get text => '$currentSlide/$slideCounts';
}

class _Used {
  bool used = false;
}

/// The BubbleShowcase main widget.
class BubbleShowcase extends StatefulWidget {
  /// When should this bubble display
  final ShowBubble showBubble;

  /// All slides.
  final List<BubbleSlide> bubbleSlides;

  /// The child widget (displayed below the showcase).
  final Widget child;

  /// TO show a counter text, it should have current slide & slides count. Defaults to null as disabled.
  final CounterText counterText;

  /// Whether to show a close button.
  final bool showCloseButton;

  // Duration by which delay showcase initialization.
  final Duration initialDelay;

  // Whether tapping anywhere will trigger the next slide. Defaults to true.
  final bool nextSlideOnTap;

  final _Used _used = _Used();

  /// Creates a new bubble showcase instance.
  BubbleShowcase({
    @required this.bubbleSlides,
    this.showBubble = ShowBubble.onlyForFirstLaunch,
    this.child,
    this.counterText,
    this.showCloseButton = true,
    this.initialDelay = Duration.zero,
    this.nextSlideOnTap = true,
  }) : assert(bubbleSlides.isNotEmpty);

  @override
  State<StatefulWidget> createState() => _BubbleShowcaseState();

  /// Whether this showcase should be opened.
  Future<bool> get shouldOpenShowcase async {
    InternalPreferences internal = await InternalPreferences.getInstance();
    switch (showBubble) {
      case ShowBubble.onlyForFirstLaunch:
        // is first launch and rendered first time
        return internal.isFirstTime && !_used.used;
      case ShowBubble.everyLaunch:
        return _used.used;
      case ShowBubble.everyTime:
      default:
        return true;
    }
  }
}

/// The BubbleShowcase state.
class _BubbleShowcaseState extends State<BubbleShowcase>
    with WidgetsBindingObserver {
  /// The current slide index.
  int _currentSlideIndex = -1;

  /// The current slide entry.
  OverlayEntry _currentSlideEntry;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await widget.shouldOpenShowcase) {
        _currentSlideIndex++;
        _currentSlideEntry = _createCurrentSlideEntry();
        await Future.delayed(widget.initialDelay);
        Overlay.of(context).insert(_currentSlideEntry);
      }
    });
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _currentSlideEntry?.remove();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_currentSlideEntry == null) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _currentSlideEntry.remove();
      Overlay.of(context).insert(_currentSlideEntry);
    });
  }

  /// Returns whether the showcasing is finished.
  bool get _isFinished =>
      _currentSlideIndex == -1 ||
      _currentSlideIndex == widget.bubbleSlides.length;

  /// Allows to go to the next entry (or to close the showcase if needed).
  void _goToNextEntryOrClose(int position) {
    _currentSlideIndex = position;
    _currentSlideEntry.remove();

    if (_isFinished) {
      _currentSlideEntry = null;
      // has been used
      widget._used.used = true;
    } else {
      _currentSlideEntry = _createCurrentSlideEntry();
      Overlay.of(context).insert(_currentSlideEntry);
    }
  }

  /// Creates the current slide entry.
  OverlayEntry _createCurrentSlideEntry() => OverlayEntry(
        builder: (context) => widget.bubbleSlides[_currentSlideIndex].build(
          context,
          widget,
          _currentSlideIndex,
          (position) {
            setState(() => _goToNextEntryOrClose(position));
          },
        ),
      );
}
