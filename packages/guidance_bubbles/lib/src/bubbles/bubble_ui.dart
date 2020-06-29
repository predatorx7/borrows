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
