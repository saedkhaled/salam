import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get username => _sharedPrefs.getString(keyUsername) ?? "";

  set username(String value) {
    _sharedPrefs.setString(keyUsername, value);
  }

  String get userUid => _sharedPrefs.getString(keyUserUid) ?? "";

  set userUid(String value) {
    _sharedPrefs.setString(keyUserUid, value);
  }

  String get userEmail => _sharedPrefs.getString(keyUserEmail) ?? "";

  set userEmail(String value) {
    _sharedPrefs.setString(keyUserEmail, value);
  }

  bool get isLoggedIn => _sharedPrefs.getBool(keyIsLoggedIn) ?? false;

  set isLoggedIn(bool value) {
    _sharedPrefs.setBool(keyIsLoggedIn, value);
  }

}

final sharedPrefs = SharedPrefs();
// constants/strings.dart
const String keyUsername = "key_username";
const String keyUserUid = "key_user_uid";
const String keyUserEmail = "key_user_email";
const String keyIsLoggedIn = "key_is_logged_in";