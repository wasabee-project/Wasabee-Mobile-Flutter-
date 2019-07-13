class UrlManager {
  static const URL_FRAG_ME = "/me";
  static const URL_FRAG_APTOK = "/aptok";
  static const URL_FRAG_API_V1 = "/api/v1";
  static const URL_FRAG_OPERATION = "/api/v1/draw/";
  static const URL_FRAG_GET_TEAM = "/api/v1/team/";
  static const BASE_API_URL = "https://server.wasabee.rocks";

  static const FULL_ME_URL = "$BASE_API_URL$URL_FRAG_ME";
  static const FULL_APTOK_URL = "$BASE_API_URL$URL_FRAG_APTOK";
  static const FULL_OPERATION_URL = "$BASE_API_URL$URL_FRAG_OPERATION";
  static const FULL_LAT_LNG_URL = "$BASE_API_URL$URL_FRAG_API_V1$URL_FRAG_ME?";
  static const FULL_GET_TEAM_URL = "$BASE_API_URL$URL_FRAG_GET_TEAM"; ///api/v1/team/{teamid}

}
