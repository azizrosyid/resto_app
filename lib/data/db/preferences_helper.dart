import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  static const _isLoggedIn = 'IS_LOGGED_IN';
  static const _username = 'USERNAME';

  Future<bool> get isLoggedIn async {
    final prefs = await sharedPreferences;
    return prefs.getBool(
          _isLoggedIn,
        ) ??
        false;
  }

  void setLoggedIn(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(_isLoggedIn, value);
  }

  Future<String> get username async {
    final prefs = await sharedPreferences;
    return prefs.getString(_username) ?? '';
  }

  void setUsername(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(_username, value);
  }

  void clear() async {
    final prefs = await sharedPreferences;
    prefs.clear();
  }

  void setImageProfile(String path) {
    sharedPreferences.then((prefs) {
      prefs.setString('image_profile', path);
    });
  }

  Future<String> getImageProfile() async {
    final prefs = await sharedPreferences;
    return prefs.getString('image_profile') ?? '';
  }
}
