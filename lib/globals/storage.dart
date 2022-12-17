import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? prefs;
  static Future<SharedPreferences> cratePref() async {
    return SharedPreferences.getInstance();
  }

  static setUser(String id, String firstName, String lastName, String email,
      bool isDisabled, SharedPreferences prefs) async {
    await prefs.setString("id", id);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setBool('isDisabled', isDisabled);
  }

  static String? getFirstName(SharedPreferences prefs) {
    return prefs.getString('firstName');
  }

  static String? getLastName(SharedPreferences prefs) {
    return prefs.getString('lastName');
  }

  static String? getEmail(SharedPreferences prefs) {
    return prefs.getString('email');
  }

  static bool? getIsDisabled(SharedPreferences prefs) {
    return prefs.getBool('isDisabled');
  }
}
