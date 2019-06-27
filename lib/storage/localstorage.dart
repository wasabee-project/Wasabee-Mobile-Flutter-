import 'package:shared_preferences/shared_preferences.dart';
import '../network/cookies.dart';

class LocalStorageUtils {
  static Future<String> getWasabeeCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CookieUtils.KEY_WASABEE_COOKIE) ?? '';
  }

  static storeWasabeeCookie(String cookie) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(CookieUtils.KEY_WASABEE_COOKIE, cookie);
  }
}
