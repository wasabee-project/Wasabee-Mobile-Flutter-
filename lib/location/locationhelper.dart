import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class LocationHelper {
  static Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static LatLng getPortalLoc(Portal portal) {
    LatLng portalLoc;
    if (portal.lat?.isNotEmpty == true && portal.lng?.isNotEmpty == true) {
      portalLoc = LatLng(double.parse(portal.lat), double.parse(portal.lng));
    }
    return portalLoc;
  }
}
