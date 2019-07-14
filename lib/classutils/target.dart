import 'package:wasabee/network/responses/operationFullResponse.dart';

class TargetUtils {
  static const DestroyPortalAlert = "DestroyPortalAlert";
  static const UseVirusPortalAlert = "UseVirusPortalAlert";
  static const LetDecayPortalAlert = "LetDecayPortalAlert";

  static String getMarkerTitle(String portalName, Target target) {
    var title = "";
    switch (target.type) {
      case DestroyPortalAlert:
        title = "Destroy - ";
        break;
      case UseVirusPortalAlert:
        title = "Virus - ";
        break;
      case LetDecayPortalAlert:
        title = "Let Decay - ";
        break;
    }
    title = "$title$portalName";
    return title;
  }

  static String getMarkerKey(Target target) {
    
  }
}