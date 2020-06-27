import 'package:shared_preferences/shared_preferences.dart';

class InternalPreferences {
  /// This will cache an instance of this object.
  static InternalPreferences _cache;

  /// The id of this package used before vars in shared_preferences's key
  static const String _id = 'org.purplegraphite.guidance_bubbles';

  /// The key id which will be used to retrieve the number of application was launched.
  static const String _launchCountKey = 'launch_count';

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
