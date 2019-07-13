import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}