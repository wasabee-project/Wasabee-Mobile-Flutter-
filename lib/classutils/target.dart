import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class TargetUtils {
  static const DestroyPortalAlert = "DestroyPortalAlert";
  static const UseVirusPortalAlert = "UseVirusPortalAlert";
  static const LetDecayPortalAlert = "LetDecayPortalAlert";

  static getMarkerTitle(String portalName, Target target) {
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

  static Future<BitmapDescriptor> getIcon(BuildContext context, Target target) async {
    String path = 'assets/icons/unknown.bmp';
    switch (target.type) {
      case LetDecayPortalAlert:
        path = 'assets/icons/decay.bmp';
        break;
      case DestroyPortalAlert:
        path = 'assets/icons/destroy.bmp';
        break;
      case UseVirusPortalAlert:
        path = 'assets/icons/virus.bmp';
        break;
    }
     final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
    return BitmapDescriptor.fromAssetImage(imageConfiguration, path);
  }
}