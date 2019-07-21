import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:latlong/latlong.dart' as latLong;

class MarkerUtilities {
  static const SEGMENT_MARKER = "wasabee_markers_";
  static const SEGMENT_ICON = "wasabee_icons_";
  static const SEGMENT_FILE_EXT = ".bmp";
  static const CONVERT_METERS_TO_MILES_CONST = 0.00062137;
  static const CONVERT_METERS_TO_YARDS_CONST = 1.0936;

  static String getImagePath(
      Target target, String googleId, String baseSegment) {
    var typePathSegment = "other_";
    switch (target.type) {
      case TargetUtils.LetDecayPortalAlert:
        typePathSegment = "decay_";
        break;
      case TargetUtils.DestroyPortalAlert:
        typePathSegment = "destroy_";
        break;
      case TargetUtils.UseVirusPortalAlert:
        typePathSegment = "virus_";
        break;
    }
    var statusPathSegment = getTargetStatusSegment(target, googleId);
    return "$baseSegment$typePathSegment$statusPathSegment$SEGMENT_FILE_EXT";
  }

  static String getTargetStatusSegment(Target target, String googleId) {
    var targetStatus = "pending";
    switch (target.state) {
      case "pending":
        break;
      case "assigned":
        if (googleId != null && target.assignedTo == googleId) {
          targetStatus = "${target.state}_yours";
        } else
          targetStatus = target.state;
        break;
      case "acknowledged":
        targetStatus = "acknowledge";
        break;
      case "completed":
        targetStatus = "done";
        break;
    }
    return targetStatus;
  }

  static double getDistanceDouble(
      LatLng firstPoint, LatLng secondPoint, bool useImperialUnits) {
    final latLong.Distance distance = new latLong.Distance();
    double distanceDouble = distance(
        latLong.LatLng(firstPoint.latitude, firstPoint.longitude),
        latLong.LatLng(secondPoint.latitude, firstPoint.longitude));
    double finalDistance;
    if (useImperialUnits) {
      //MILES
      finalDistance = distanceDouble * CONVERT_METERS_TO_MILES_CONST;
    } else {
      //KM
      finalDistance = distanceDouble / 1000;
    }
    return finalDistance;
  }

  static String getDistanceString(double distanceBig, bool useImperialUnits) {
    double finalDistance;
    String finalDistanceUnits;
    if (useImperialUnits) {
      //MILES
      finalDistanceUnits = "mi";
      finalDistance = distanceBig;
      if (distanceBig < 1) {
        //YARDS
        finalDistanceUnits = "yards";
        finalDistance = distanceBig *
            CONVERT_METERS_TO_YARDS_CONST; // need to convert miles to yards, not meters
      }
    } else {
      //KM
      finalDistanceUnits = "km";
      finalDistance = distanceBig;
      if (distanceBig < 1) {
        //METERS
        finalDistanceUnits = "meters";
        finalDistance = distanceBig * 1000;
      }
    }
    return "$finalDistance $finalDistanceUnits";
  }

  static String getDistanceUnits(
      LatLng firstPoint, LatLng secondPoint, bool useImperialUnits) {
    final latLong.Distance distance = new latLong.Distance();
    double distanceDouble = distance(
        latLong.LatLng(firstPoint.latitude, firstPoint.longitude),
        latLong.LatLng(secondPoint.latitude, firstPoint.longitude));
    String units;
    if (useImperialUnits) {
      //MILES
      units = "mi";
      if (distanceDouble * CONVERT_METERS_TO_MILES_CONST < 1) //YARDS
        units = "yards";
    } else {
      //KM
      units = "km";
      if (distanceDouble / 1000 < 1) //METERS
        units = "meters";
    }
    return units;
  }
}
