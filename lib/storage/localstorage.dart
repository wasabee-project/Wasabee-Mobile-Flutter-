import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static const KEY_SELECTED_OPERATION = "KEY_SELECTED_OPERATION";
  static const KEY_SHARING_LOCATION = "KEY_SHARING_LOCATION";
  static const KEY_GOOGLE_ID = "KEY_GOOGLE_ID";

  static Future<String> getSelectedOpId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_SELECTED_OPERATION) ?? '';
  }

  static storeSelectedOpId(String operationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_SELECTED_OPERATION, operationId);
  }

  static Future<bool> getIsLocationSharing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_SHARING_LOCATION) ?? false;
  }

  static storeIsLocationSharing(bool isLocationSharing) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_SHARING_LOCATION, isLocationSharing);
  }

  static Future<String> getGoogleId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_GOOGLE_ID) ?? null;
  }

  static storeGoogleId(String googleId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_GOOGLE_ID, googleId);
  }
}
