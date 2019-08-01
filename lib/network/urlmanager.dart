import 'package:url_launcher/url_launcher.dart';

class UrlManager {
  static const URL_FRAG_ME = "/me";
  static const URL_FRAG_APTOK = "/aptok";
  static const URL_FRAG_API_V1 = "/api/v1";
  static const URL_FRAG_OPERATION = "/api/v1/draw/";
  static const URL_FRAG_GET_TEAM = "/api/v1/team/";
  static const URL_FRAG_DRAW = "/draw/";
  static const URL_FRAG_MARKER = "/marker/";
  static const URL_FRAG_LINK = "/link/";
  static const URL_FRAG_COMPLETE = "/complete";
  static const URL_FRAG_INCOMPLETE = "/incomplete";
  static const URL_FRAG_REJECT = "/reject";
  static const URL_FRAG_ACKNOWLEDGE = "/acknowledge";
  static const BASE_API_URL = "https://server.wasabee.rocks";

  static const FULL_ME_URL = "$BASE_API_URL$URL_FRAG_ME";
  static const FULL_APTOK_URL = "$BASE_API_URL$URL_FRAG_APTOK";
  static const FULL_OPERATION_URL = "$BASE_API_URL$URL_FRAG_OPERATION";
  static const FULL_LAT_LNG_URL = "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_ME?";
  static const FULL_GET_TEAM_URL = "$BASE_API_URL$URL_FRAG_GET_TEAM";

  static String getCompleteLinkUrl(String opId, String linkId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_LINK$linkId$URL_FRAG_COMPLETE";
  }

  static String getInCompleteLinkUrl(String opId, String linkId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_LINK$linkId$URL_FRAG_INCOMPLETE";
  }

  static String getCompleteMarkerUrl(String opId, String markerId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_MARKER$markerId$URL_FRAG_COMPLETE";
  }

  static String getInCompleteMarkerUrl(String opId, String markerId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_MARKER$markerId$URL_FRAG_INCOMPLETE";
  }

  static String getRejectMarkerUrl(String opId, String markerId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_MARKER$markerId$URL_FRAG_REJECT";
  }

  static String getAcknowledgeMarkerUrl(String opId, String markerId) {
    return "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_DRAW$opId$URL_FRAG_MARKER$markerId$URL_FRAG_ACKNOWLEDGE";
  }

  static launchIntelUrl(String lat, String lng) {
    String url = 'https://intel.ingress.com/intel?ll=$lat,$lng&pll=$lat,$lng';
    canLaunch(url).then((canLaunch) {
      launch(url);
    });
  }
}
