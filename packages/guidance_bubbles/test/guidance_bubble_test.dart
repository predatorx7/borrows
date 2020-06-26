import 'package:flutter_test/flutter_test.dart';

import 'package:guidance_bubbles/src/_internal.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Tests for internal launch count service', () async {
    final String _key = 'org.purplegraphite.guidance_bubbles/launch_count';
    SharedPreferences.setMockInitialValues({
      '${_key}0': 0,
      '${_key}1': 1,
      '${_key}2': 4,
      '${_key}3': null,
      '${_key}4': -1,
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (var index in <int>[0, 1, 2, 3, 4]) {
      int mockCount = preferences?.getInt('$_key$index');
      if (mockCount == null) {
        mockCount = 1;
      } else {
        mockCount += 1;
      }
      GuidanceBubbleInternal x = await GuidanceBubbleInternal.fromFactory();
      expect(x.launchCount, mockCount,
          reason:
              'ThisLaunchCountFromService: ${x.launchCount} MockCount: $mockCount, fromPrefs:${preferences?.getInt('$_key$index')}');
      expect(x.isFirstTime, mockCount == 1);
    }
  });
}
