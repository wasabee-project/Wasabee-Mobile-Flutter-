import '../storage/localstorage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../network/urlmanager.dart';


class CookieUtils {
  static const KEY_WASABEE_COOKIE = "WASABI";

  static Future<bool> hasWasabeeCookie(CookieJar cj) async {
    var cookieList = cj.loadForRequest(Uri.parse(UrlManager.BASE_API_URL));
    for (var cookie in cookieList) {
      print('cookie Name -> ${cookie.name}');
      if (cookie.name == KEY_WASABEE_COOKIE) {
        LocalStorageUtils.storeWasabeeCookie(cookie.value);
        return true;
      }
    }
    return false;
  }
}
