import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'shape.dart';
import 'showcase.dart';
import 'utils.dart';

/// A function that allows to calculate a position according to a provided size.
typedef PositionCalculator = Position Function(Size size);

/// A simple bubble slide that allows to highlight a specific screen zone.
abstract class BubbleSlide {
  /// The slide shape.
  final Shape shape;

  /// The box shadow.
  final BoxShadow boxShadow;

  /// The slide child.
  final BubbleSlideChild child;

  // The slide child build function (optional). Receives the `nextSlide` function used to trigger slide changes.
  final BubbleSlideChild Function(BuildContext, Function) builder;

  // Duration by which slide will be visible on screen, before switching to the next slide.
  final Duration duration;

  // Whether the slide should be dismissed when tapping anywhere on the screen. Defaults to false.
  final bool disableOutsideTap;

  /// Creates a new bubble slide instance.
  const BubbleSlide({
    this.shape = const Rectangle(),
    this.boxShadow = const BoxShadow(
      color: Colors.black54,
      blurRadius: 0,
      spreadRadius: 0,
    ),
    this.child,
    this.duration,
    this.disableOutsideTap = false,
    this.builder,
  });

  /// Builds the whole slide widget.
  Widget build(BuildContext context, BubbleShowcase bubbleShowcase,
      int currentSlideIndex, void Function(int) goToSlide) {
    Position highlightPosition =
        getHighlightPosition(context, bubbleShowcase, currentSlideIndex);
    List<Widget> children = [
      Positioned.fill(
        child: CustomPaint(
          painter: OverlayPainter(this, highlightPosition),
        ),
      ),
    ];

    void _defaultAction() {
      goToSlide(currentSlideIndex + 1);
    }

    var childWidget = child;

    if (builder != null) {
      childWidget = builder(context, _defaultAction);
    }

    if (childWidget != null && childWidget.widget != null) {
      children.add(childWidget.build(
          context, highlightPosition, MediaQuery.of(context).size));
    }

    int slidesCount = bubbleShowcase.bubbleSlides.length;
    Color writeColor =
        Utils.isColorDark(boxShadow.color) ? Colors.white : Colors.black;
    if (bubbleShowcase.counterText != null) {
      bubbleShowcase.counterText
        ..setCurrentSlide(currentSlideIndex + 1)
        ..setSlideCount(slidesCount);
      children.add(
        Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: Text(
            bubbleShowcase.counterText.text,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: writeColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (bubbleShowcase.showCloseButton) {
      children.add(Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        child: GestureDetector(
          child: Icon(
            Icons.close,
            color: writeColor,
          ),
          onTap: () => goToSlide(slidesCount),
        ),
      ));
    }

    if (duration != null) {
      Future.delayed(duration).then((_) => _defaultAction());
      return GestureDetector(
        onTap: () {},
        child: Stack(
          children: children,
        ),
      );
    }

    return GestureDetector(
      onTap: disableOutsideTap ? () {} : _defaultAction,
      child: Stack(
        children: children,
      ),
    );
  }

  /// Returns the position to highlight.
  Position getHighlightPosition(BuildContext context,
      BubbleShowcase bubbleShowcase, int currentSlideIndex);
}

/// A bubble slide with a position that depends on another widget.
class RelativeBubbleSlide extends BubbleSlide {
  /// The widget key.
  final GlobalKey widgetKey;

  /// Creates a new relative bubble slide instance.
  const RelativeBubbleSlide({
    Shape shape = const Rectangle(),
    BoxShadow boxShadow = const BoxShadow(
      color: Colors.black54,
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BubbleSlideChild child,
    Function(BuildContext, Function) builder,
    Duration duration,
    bool disableOutsideTap,
    @required this.widgetKey,
  }) : super(
          shape: shape,
          boxShadow: boxShadow,
          child: child,
          builder: builder,
          duration: duration,
          disableOutsideTap: disableOutsideTap ?? false,
        );

  @override
  Position getHighlightPosition(BuildContext context,
      BubbleShowcase bubbleShowcase, int currentSlideIndex) {
    RenderBox renderBox =
        widgetKey.currentContext.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return Position(
      top: offset.dy,
      right: offset.dx + renderBox.size.width,
      bottom: offset.dy + renderBox.size.height,
      left: offset.dx,
    );
  }
}

/// A bubble slide with an absolute position on the screen.
class AbsoluteBubbleSlide extends BubbleSlide {
  /// The function that allows to compute the highlight position according to the parent size.
  final PositionCalculator positionCalculator;

  /// Creates a new absolute bubble slide instance.
  const AbsoluteBubbleSlide({
    Shape shape = const Rectangle(),
    BoxShadow boxShadow = const BoxShadow(
      color: Colors.black54,
      blurRadius: 0,
      spreadRadius: 0,
    ),
    BubbleSlideChild child,
    @required this.positionCalculator,
    Function(BuildContext, Function) builder,
    Duration duration,
    bool disableOutsideTap,
  }) : super(
          shape: shape,
          boxShadow: boxShadow,
          child: child,
          builder: builder,
          duration: duration,
          disableOutsideTap: disableOutsideTap ?? false,
        );

  @override
  Position getHighlightPosition(BuildContext context,
          BubbleShowcase bubbleShowcase, int currentSlideIndex) =>
      positionCalculator(MediaQuery.of(context).size);
}

/// A bubble slide child, holding a widget.
abstract class BubbleSlideChild {
  /// The held widget.
  final Widget widget;

  /// Creates a new bubble slide child instance.
  const BubbleSlideChild({
    this.widget,
  });

  /// Builds the bubble slide child widget.
  Widget build(BuildContext context, Position targetPosition, Size parentSize) {
    Position position = getPosition(context, targetPosition, parentSize);
    return Positioned(
      top: position.top,
      right: position.right,
      bottom: position.bottom,
      left: position.left,
      child: widget,
    );
  }

  /// Returns child position according to the highlight position and parent size.
  Position getPosition(
      BuildContext context, Position highlightPosition, Size parentSize);
}

/// A bubble slide with a position that depends on the highlight zone.
class RelativeBubbleSlideChild extends BubbleSlideChild {
  /// The child direction.
  final AxisDirection direction;

  /// Creates a new relative bubble slide child instance.
  const RelativeBubbleSlideChild({
    Widget widget,
    this.direction = AxisDirection.down,
  }) : super(
          widget: widget,
        );

  @override
  Position getPosition(
      BuildContext context, Position highlightPosition, Size parentSize) {
    switch (direction) {
      case AxisDirection.up:
        return Position(
          right: parentSize.width - highlightPosition.right,
          bottom: parentSize.height - highlightPosition.top,
          left: highlightPosition.left,
        );
      case AxisDirection.right:
        return Position(
          top: highlightPosition.top,
          bottom: parentSize.height - highlightPosition.bottom,
          right: parentSize.width - highlightPosition.left,
        );
      case AxisDirection.left:
        return Position(
          top: highlightPosition.top,
          bottom: parentSize.height - highlightPosition.bottom,
          left: highlightPosition.right,
        );
      default:
        return Position(
          top: highlightPosition.bottom,
          right: parentSize.width - highlightPosition.right,
          left: highlightPosition.left,
        );
    }
  }
}

/// A bubble slide child with an absolute position on the screen.
class AbsoluteBubbleSlideChild extends BubbleSlideChild {
  /// The function that allows to compute the child position according to the parent size.
  final PositionCalculator positionCalculator;

  /// Creates a new absolute bubble slide child instance.
  const AbsoluteBubbleSlideChild({
    Widget widget,
    @required this.positionCalculator,
  }) : super(
          widget: widget,
        );

  @override
  Position getPosition(
          BuildContext context, Position highlightPosition, Size parentSize) =>
      positionCalculator(parentSize);
}
