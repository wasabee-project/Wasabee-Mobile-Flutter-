import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../network/cookies.dart';
import 'dart:convert' as convert;

class NetworkCalls {
  static void doNetworkCall(
      String url,
      Map<String, String> sendData,
      Function(String) callback,
      bool includeCookie,
      NetWorkCallType callType) async {
    var dio = new Dio();
    var cj = CookieJar();
    var cm = CookieManager(cj);
    dio.interceptors.add(cm);

    print('Doing Network Call -> $url with data $sendData');

    Response response;

    switch (callType) {
      case NetWorkCallType.GET:
          response = await dio.get(url);
        break;
      case NetWorkCallType.POST:
          response = await dio.post(url, data: convert.jsonEncode(sendData));
        break;
      case NetWorkCallType.PUT:
          response = await dio.put(url, data: convert.jsonEncode(sendData));
        break;
      default:
        break;
    }
    print('Response for $url is -> $response');
    if (response != null && response.statusCode == 200) {
      var cookieList = cj.loadForRequest(Uri.parse(url));
      CookieUtils.saveWasabeeCookieFromList(cookieList, cm);
      callback(response.data.toString());
    }
  }
}

enum NetWorkCallType { PUT, POST, GET }
