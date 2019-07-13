import 'dart:math';
import 'dart:ui';
import 'package:vector_math/vector_math.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wasabee/network/responses/teamsResponse.dart';
import '../classutils/target.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Images;
import 'dart:async';

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
    return distance;
  }

  static double getZoomLevel(Circle circle) {
    double zoomlevel = 14.0;
    if (circle != null) {
      double radius = circle.radius;
      double scale = radius / 500;
      zoomlevel = (16 - log(scale) / log(2));
    }
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
    return LatLng(finalLat, finalLon);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MapMarkerBitmapBank {
  Map<String, BitmapDescriptor> bank = Map();

  Future<BitmapDescriptor> getIconFromBank(
      String key, BuildContext context, Agent agent) async {
    BitmapDescriptor bmd = bank[key];
    if (bmd != null) {
      print("Size of Bank -> ${bank.length}");
      return bmd;
    } else {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      if (key.startsWith("agent_")) {
        bmd = await getAgentImage(key, imageConfiguration, context);// await getUrlAvatarMarker(agent.pic, imageConfiguration, key, context);
      } else {
        print('getting existing from key -> $key');
        bmd = await BitmapDescriptor.fromAssetImage(
            imageConfiguration, getPathFromKey(key));
      }
      bank[key] = bmd;
      return bmd;
    }
  }

  Future<BitmapDescriptor> getAgentImage(String key,
      ImageConfiguration imageConfiguration, BuildContext context) async {
        print('getting backup agent image');
    return await BitmapDescriptor.fromAssetImage(
        imageConfiguration, 'assets/icons/avatar.bmp');
  }

  Future<BitmapDescriptor> getUrlAvatarMarker(
      String url, ImageConfiguration configuration, String key, BuildContext context) async {
    var agentAvatar;
    // load avatar image
    ByteData imageData = await rootBundle.load('assets/icons/avatar.png');
    var markerImage = Images.decodeImage(Uint8List.view(imageData.buffer));

    //load marker image
    Image downloadImage = new Image.network(url);
    final ImageStream stream = downloadImage.image.resolve(configuration);
    final Completer<void> completer = Completer<void>();
    stream.addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
      print('imageInfo -> $info');
      print('imageInfo.image -> ${info.image}');
      info.image.toByteData().then((byteData) {
        print('byteData.buffer -> ${byteData.buffer.toString()}');
        var data = Uint8List.view(byteData.buffer);
        print('data -> $data');
        agentAvatar = Images.decodeImage(data);
        print('agent avatar -> $agentAvatar');
        completer.complete();
      });
    }));
    await completer.future;

    //resize the avatar image to fit inside the marker image
    if (markerImage.width == null ||
        markerImage.height == null ||
        agentAvatar == null) {
          print('returning null agent thing');
      return await getAgentImage(key, configuration, context);
    } else {
      print('doing thing');
      agentAvatar = Images.copyResize(agentAvatar,
          width: markerImage.width ~/ 1.1, height: markerImage.height ~/ 1.4);

      var radius = 30;
      int originX = agentAvatar.width ~/ 2, originY = agentAvatar.height ~/ 2;

      //draw the avatar image cropped as a circle inside the marker image
      for (int y = -radius; y <= radius; y++)
        for (int x = -radius; x <= radius; x++)
          if (x * x + y * y <= radius * radius)
            markerImage.setPixelSafe(originX + x + 8, originY + y + 10,
                agentAvatar.getPixelSafe(originX + x, originY + y));

      return BitmapDescriptor.fromBytes(Images.encodePng(markerImage));
    }
  }

  String getPathFromKey(String key) {
    String path = 'assets/icons/unknown.bmp';
    switch (key) {
      case TargetUtils.LetDecayPortalAlert:
        path = 'assets/icons/decay.bmp';
        break;
      case TargetUtils.DestroyPortalAlert:
        path = 'assets/icons/destroy.bmp';
        break;
      case TargetUtils.UseVirusPortalAlert:
        path = 'assets/icons/virus.bmp';
        break;
      case "groupa":
        path = 'assets/icons/groupa_2.bmp';
        break;
      case "groupb":
        path = 'assets/icons/groupb.bmp';
        break;
      case "groupc":
        path = 'assets/icons/groupc.bmp';
        break;
      case "groupd":
        path = 'assets/icons/groupd.bmp';
        break;
      case "groupe":
        path = 'assets/icons/groupe.bmp';
        break;
      case "groupf":
        path = 'assets/icons/groupf.bmp';
        break;
    }
    return path;
  }
}
