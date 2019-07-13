import 'package:cookie_jar/cookie_jar.dart';
import '../network/urlmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class CookieUtils {
  static const KEY_WASABEE_COOKIE = "wasabee";

  static Future<bool> hasWasabeeCookie(CookieJar cj) async {
    var cookieList = cj.loadForRequest(Uri.parse(UrlManager.BASE_API_URL));
    for (var cookie in cookieList) {
      print('cookie Name -> ${cookie.name}');
      if (cookie.name == KEY_WASABEE_COOKIE) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> clearAllCookies() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var directory = await new Directory(appDocDirectory.path + '/' + 'cookies')
        .create(recursive: true);
    var cj = new PersistCookieJar(
      dir: directory.path,
      ignoreExpires: false,
    );
    cj.deleteAll();
    return true;
  }
}
