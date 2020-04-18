import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/pages/mappage/utilities.dart';

class MapViewWidget extends StatefulWidget {
  final MapPageState mapPageState;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final LatLngBounds visibleRegion;

  MapViewWidget({
    Key key,
    @required this.mapPageState,
    this.markers,
    this.polylines,
    this.visibleRegion,
  }) : super(key: key);
  MapViewState createState() =>
      MapViewState(mapPageState, markers, polylines, visibleRegion);
}

class MapViewState extends State<MapViewWidget>
    with AutomaticKeepAliveClientMixin {
  MapPageState mapPageState;
  Map<MarkerId, Marker> markers;
  Map<PolylineId, Polyline> polylines;
  LatLngBounds visibleRegion;

  MapViewState(mapPageState, markers, polylines, visibleRegion) {
    this.mapPageState = mapPageState;
    this.markers = markers;
    this.polylines = polylines;
    this.visibleRegion = visibleRegion;
  }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getMapContent();
  }

  Widget getMapContent() {
    var locationList = MapUtilities.getLatLngListFromMarkers(List<Marker>.of(markers.values));
    var center = visibleRegion == null
        ? MapUtilities.computeCentroid(locationList)
        : MapUtilities.getCenterFromBounds(visibleRegion);
    var bounds = visibleRegion == null
        ? MapUtilities.getBounds(locationList)
        : visibleRegion;
    var fromExistingLocation = visibleRegion != null;
    return Scaffold(
      body: GoogleMap(
        onMapCreated: mapPageState.onMapCreated,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        initialCameraPosition: CameraPosition(
            target: center,
            zoom: MapUtilities.getViewCircleZoomLevel(
                center, bounds, fromExistingLocation)
            ),
       ),
    );
  }
}
