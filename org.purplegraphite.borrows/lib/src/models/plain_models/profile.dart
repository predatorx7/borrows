/// Serializes user profile information
/// to retrieve Profile information from database snapshot using adapters & services.
class Profile {
  String key;

  /// Email of user
  String email;

  /// Full Name of User.
  String fullName;

  /// User's gender.
  /// Gender Should be: Male, Female, <custom>, and Prefer not to say.
  String gender;

  /// ProfileImageId for this user.
  String profileImage;

  /// Firebase uid of this user.
  String uid;

  /// App username of this user.
  String username;

  /// Raw data map
  Map<dynamic, dynamic> dataMap;

  Profile(
      {this.email,
      this.fullName,
      this.gender,
      this.profileImage,
      this.uid,
      this.username});

  Profile.fromMap(Map mainData) {
    key = mainData['key'] ?? '';
    uid = mainData['uid'] ?? '';
    email = mainData['email'] ?? '';
    fullName = mainData['fullName'] ?? '';
    gender = mainData['gender'] ?? '';
    profileImage = mainData['profileImage'] ?? '';
    username = mainData['username'] ?? '';
  }

  _tryAssign(String key, Map data, replace) {
    dynamic x;
    try {
      x = data[key];
    } catch (e) {
      x = replace;
    }
    return x;
  }

  Profile.fromValue(Map mainData) {
    uid = _tryAssign('uid', mainData, '');
    email = _tryAssign('email', mainData, '');
    fullName = _tryAssign('fullName', mainData, '');
    gender = _tryAssign('gender', mainData, '');
    profileImage = _tryAssign('profileImage', mainData, '');
    username = _tryAssign('username', mainData, '');
  }

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "email": email,
      "fullName": fullName,
      "gender": gender,
      "profileImage": profileImage,
      "uid": uid,
      "username": username
    };
  }
}
