import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtilities {
  static double getViewCircleZoomLevel(LatLng center, List<Marker> markers) {
    Circle circle = Circle(
        center: center,
        radius: calculateDistance(getBounds(markers)),
        circleId: null);
    return getZoomLevel(circle);
  }

  static double calculateDistance(LatLngBounds bounds) {
    var lat1 = bounds.southwest.latitude;
    var lon1 = bounds.southwest.longitude;
    var lat2 = bounds.northeast.latitude;
    var lon2 = bounds.northeast.longitude;
    var earthRadiusKm = 6371;
    var dLat = radians(lat2 - lat1);
    var dLon = radians(lon2 - lon1);

    lat1 = radians(lat1);
    lat2 = radians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = earthRadiusKm * c * 1000;
    print('calculated distance -> $distance');
    return distance;
  }

  static double getZoomLevel(Circle circle) {
    double zoomlevel = 14.0;
    if (circle != null) {
      double radius = circle.radius;
      double scale = radius / 500;
      zoomlevel = (16 - log(scale) / log(2));
    }
    print('zoomlevel -> $zoomlevel');
    return zoomlevel;
  }

  static LatLng computeCentroid(List<Marker> markers) {
    double latitude = 0;
    double longitude = 0;
    int n = markers.length;

    for (Marker point in markers) {
      latitude += point.position.latitude;
      longitude += point.position.longitude;
    }

    return new LatLng(latitude / n, longitude / n);
  }

  static LatLngBounds getBounds(List<Marker> markers) {
    return new LatLngBounds(
        northeast: getNorthEast(markers), southwest: getSouthWest(markers));
  }

  static LatLng getNorthEast(List<Marker> markers) {
    double finalLat = 0;
    double finalLon = 0;
    for (var marker in markers) {
      if (finalLat == 0)
        finalLat = marker.position.latitude;
      else if (marker.position.latitude > finalLat)
        finalLat = marker.position.latitude;

      if (finalLon == 0)
        finalLon = marker.position.longitude;
      else if (marker.position.longitude > finalLon)
        finalLon = marker.position.longitude;
    }
    print('NorthEast -> Lat: $finalLat, Lon: $finalLon');
    return LatLng(finalLat, finalLon);
  }

  static LatLng getSouthWest(List<Marker> markers) {
    double finalLat = 0;
    double finalLon = 0;
    for (var marker in markers) {
      if (finalLat == 0)
        finalLat = marker.position.latitude;
      else if (marker.position.latitude < finalLat)
        finalLat = marker.position.latitude;

      if (finalLon == 0)
        finalLon = marker.position.longitude;
      else if (marker.position.longitude < finalLon)
        finalLon = marker.position.longitude;
    }

    print('SouthWest -> Lat: $finalLat, Lon: $finalLon');
    return LatLng(finalLat, finalLon);
  }
}
