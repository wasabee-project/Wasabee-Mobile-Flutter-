import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/src/interceptors/cookie_mgr.dart';
import '../storage/localstorage.dart';
import '../network/urlmanager.dart';

class CookieUtils {
  static const KEY_WASABEE_COOKIE = "WASABEE";

  static void saveWasabeeCookieFromList(List<Cookie> cookieList, CookieManager cm) {
    for (var cookie in cookieList) {
      print('Cookie -> $cookie');
      if (cookie.name == KEY_WASABEE_COOKIE) {
        LocalStorageUtils.storeWasabeeCookie(cookie.value);
        return;
      }
    }
    setCookieForUrls(cm);
  }

  static void setCookieForUrls(CookieManager cm) {
    var listOfUrls = List();
    listOfUrls.add(UrlManager.URL_ME);

    for (var url in listOfUrls) {
      //cm.cookieJar.loadForRequest(uri)
    }
  }
}
