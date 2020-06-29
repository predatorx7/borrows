import 'package:shared_preferences/shared_preferences.dart';

class UniqueBubble {
  final String uid;
  UniqueBubble(this.uid);
}

class UniqueBubbleBox {
  List<UniqueBubble> _uniqueBubbleUIDs = <UniqueBubble>[];
  List<UniqueBubble> get uniqueBubbleUIDs => _uniqueBubbleUIDs;
  String _uidHasFocus;
  bool hasFocus(String uid) {
    if (_uidHasFocus == null) {
      return false;
    }
    return _uidHasFocus == uid;
  }

  String get whoHasFocus => _uidHasFocus;

  void setFocus(String uid) {
    for (var item in _uniqueBubbleUIDs) {
      if (item.uid == uid) {
        _uidHasFocus = uid;
        return;
      }
      throw Exception('Cannot set focus to $uid. $uid is not registered.');
    }
  }

  void add(String uid) {
    for (var item in _uniqueBubbleUIDs) {
      if (item.uid == uid) {
        print(
            '[guidance_bubbles] Widget with same bubble UID already exists. If you are using a unique UID then make sure the widget\'s instance  is not recreated.');
        return;
      }
    }
    _uniqueBubbleUIDs.add(UniqueBubble(uid));
  }
}

class InternalPreferences {
  /// This will cache an instance of this object.
  static InternalPreferences _cache;

  /// The id of this package used before vars in shared_preferences's key
  static const String _id = 'org.purplegraphite.guidance_bubbles';

  /// The key id which will be used to retrieve the number of application was launched.
  static const String _launchCountKey = 'launch_count';

  /// Stores all UID
  final UniqueBubbleBox uniqueBubbleBox = UniqueBubbleBox();

  /// internal constructor
  InternalPreferences._();

  /// This will be internally used to check nth time the application has been launched.
  SharedPreferences _preferences;

  /// initialization status of this object
  bool _isInitialized = false;

  int _launchCount = 0;

  int get launchCount => _launchCount;

  /// Returns true if this is the first time this app has been launched.
  bool get isFirstTime => (launchCount == 1);

  /// Returns a singleton Future instance of [InternalPreferences] with initialized preferences.
  static Future<InternalPreferences> getInstance() async {
    if (_cache == null) {
      _cache = InternalPreferences._();
      await _cache._ensureInitialized();
    }
    return _cache;
  }

  Future<void> _handleLaunchCount() async {
    final String _countKey = '$_id/$_launchCountKey';
    final int _previousLaunchCount = (_preferences?.getInt(_countKey) ?? 0);
    if (_previousLaunchCount <= 0) {
      if (_previousLaunchCount < 0) {
        // An unknown error as value couldn't be less than 0, setting this launch as first time. Reaching this block is not possible,
        // but if someone tampers or modifies this value from another point in the application,
        // then this may happen.
        print('[guidance_bubbles] Unknown error.');
      }
      // This is the first time. We'll set the value to 1 to mark this launch.
      _launchCount = 1;
    } else {
      // all ok
      // This launch count must be more than 1.
      // marking this +1 than the previous count.
      _launchCount = _previousLaunchCount + 1;
    }
    await _preferences.setInt(_countKey, _launchCount);
  }

  /// Used in [InternalPreferences] factory. Not required to call again.
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    _preferences = await SharedPreferences.getInstance();
    _isInitialized = true;
    await _handleLaunchCount();
  }
}
