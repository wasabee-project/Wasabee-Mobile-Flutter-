import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latLong;

class DistanceUtilities {
  static const CONVERT_METERS_TO_MILES_CONST = 0.00062137;
  static const CONVERT_METERS_TO_YARDS_CONST = 1.0936;
  static const CONVERT_MILES_TO_YARDS_CONST = 1760;

  static double getDistanceMeters(LatLng firstPoint, LatLng secondPoint) {
    //THIS IS WRONG! D:
    final latLong.Distance distance = new latLong.Distance();
    return distance(latLong.LatLng(firstPoint.latitude, firstPoint.longitude),
        latLong.LatLng(secondPoint.latitude, firstPoint.longitude));
  }

  static double getDistanceDouble(
      LatLng firstPoint, LatLng secondPoint, bool useImperialUnits) {
    double finalDistance = 0.0;
    if (firstPoint != null && secondPoint != null) {
      double distanceDouble = getDistanceMeters(firstPoint, secondPoint);
      if (useImperialUnits) {
        //MILES
        finalDistance = distanceDouble * CONVERT_METERS_TO_MILES_CONST;
      } else {
        //KM
        finalDistance = distanceDouble / 1000;
        print('from -> ${firstPoint.latitude}, ${firstPoint.longitude}');
        print('to -> ${secondPoint.latitude}, ${secondPoint.longitude}');
        print('finalDistance -> $finalDistance');
      }
    }
    return finalDistance;
  }

  static String getDistanceString(double distanceBig, bool useImperialUnits) {
    String finalDistanceUnits;
    String finalDistanceString;
    if (useImperialUnits) {
      //MILES
      finalDistanceUnits = "mi";
      finalDistanceString = "${distanceBig.toStringAsFixed(2)}";
      if (distanceBig < 1) {
        //YARDS
        print('distanceBig -> $distanceBig');
        finalDistanceUnits = "yards";
        finalDistanceString = (distanceBig * CONVERT_MILES_TO_YARDS_CONST)
            .toStringAsFixed(0); // need to convert miles to yards, not meters
      }
    } else {
      //KM
      finalDistanceUnits = "km";
      finalDistanceString = "${distanceBig.toStringAsFixed(2)}";
      if (distanceBig < 1) {
        //METERS
        finalDistanceUnits = "meters";
        finalDistanceString = (distanceBig * 1000).toStringAsFixed(0);
      }
    }
    return "$finalDistanceString $finalDistanceUnits";
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
