import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import '../network/networkcalls.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  final List<Ops> ops;

  MapPage({Key key, @required this.ops}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState(ops);
}

class _MapPageState extends State<MapPage> {
  var isLoading = false;
  var pendingGrab;
  GoogleMapController _controller;
  final LatLng _center = const LatLng(32.7766642, -96.7969879);
  List<Ops> operationList = List();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  _MapPageState(List<Ops> ops) {
    this.operationList = ops;
    if (this.operationList.length > 0) {
      operationList.first.isSelected = true;
      this.pendingGrab = operationList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pendingGrab != null) getFullOperation(pendingGrab);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasabee - Map'),
        backgroundColor: Colors.green[700],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
      drawer: isLoading
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: getDrawerElements(),
              ),
            ),
    );
  }

  getFullOperation(Ops op) {
    isLoading = true;
    pendingGrab = null;
    try {
      var url = "https://server.wasabee.rocks/api/v1/draw/${op.iD}";
      NetworkCalls.doNetworkCall(
          url, Map<String, String>(), gotOperation, false, NetWorkCallType.GET);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  gotOperation(response) {
    var operation = OperationFullResponse.fromJson(json.decode(response));
    markers.clear();
    polylines.clear();
    populateAnchors(operation);
    populateLinks(operation);

    setState(() {
      isLoading = false;
    });
  }

  populateAnchors(OperationFullResponse operation) {
    for (var anchor in operation.anchors) {
      final MarkerId markerId = MarkerId(anchor);
      final Portal portal = operation.getPortalFromID(anchor);
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          double.parse(portal.lat),
          double.parse(portal.lng),
        ),
        infoWindow: InfoWindow(
            title: portal.name, snippet: 'Links: ${operation.links.length}'),
        onTap: () {
          _onMarkerTapped(markerId);
        },
      );
      markers[markerId] = marker;
      print('markers = $markers');
    }
  }

  _onMarkerTapped(MarkerId markerId) {
    print('Tapped Marker: ${markerId.value}');
  }

  populateLinks(OperationFullResponse operation) {
    for (var link in operation.links) {
      final PolylineId polylineId = PolylineId(link.iD);
      final Portal fromPortal = operation.getPortalFromID(link.fromPortalId);
      final Portal toPortal = operation.getPortalFromID(link.toPortalId);
      final List<LatLng> points = <LatLng>[];
      points.add(LatLng(double.parse(fromPortal.lat),double.parse(fromPortal.lng)));
      points.add(LatLng(double.parse(toPortal.lat),double.parse(toPortal.lng)));
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: true,
        color: Colors.orange,
        width: 5,
        points: points,
        geodesic: true,
        onTap: () {
          _onPolylineTapped(polylineId);
        },
      );
      polylines[polylineId] = polyline;
      print('markers = $markers');
    }
  }

  void _onPolylineTapped(PolylineId polylineId) {
    print('Tapped Polyline: ${polylineId.value}');
  }

  List<Widget> getDrawerElements() {
    if (operationList.isEmpty) {
      return <Widget>[
        DrawerHeader(
          child: Text(
            'Wasabee Operations',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
          decoration: BoxDecoration(
            color: Colors.green,
          ),
        ),
      ];
    } else {
      var listOfElements = List<Widget>();
      listOfElements.add(DrawerHeader(
        child: Text(
          'Wasabee Operations',
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        decoration: BoxDecoration(
          color: Colors.green,
        ),
      ));
      for (var op in operationList) {
        listOfElements.add(ListTile(
          title: Text(op.name),
          selected: op.isSelected,
          onTap: () {
            tappedOp(op, operationList);
            Navigator.pop(context);
          },
        ));
      }
      return listOfElements;
    }
  }

  tappedOp(Ops op, List<Ops> operationList) {
    setState(() {
      pendingGrab = op;
      for (var ops in operationList) {
        if (op.iD == ops.iD)
          ops.isSelected = true;
        else
          ops.isSelected = false;
      }
    });
  }
}
