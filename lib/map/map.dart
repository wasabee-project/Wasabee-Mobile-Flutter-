import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/login/login.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import '../network/networkcalls.dart';
import '../network/urlmanager.dart';
import '../storage/localstorage.dart';
import '../map/utilities.dart';
import '../main.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  final List<Ops> ops;

  MapPage({Key key, @required this.ops}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState(ops);
}

class _MapPageState extends State<MapPage> {
  var firstLoad = true;
  var isLoading = false;
  var pendingGrab;
  Ops selectedOperation;
  GoogleMapController _controller;
  final LatLng _center = const LatLng(32.7766642, -96.7969879);
  List<Ops> operationList = List();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> targets = <MarkerId, Marker>{};

  _MapPageState(List<Ops> ops) {
    this.operationList = ops;
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad == true) {
      firstLoad = false;
      doInitialLoadThings();
    }
    return checkPendingGrabAndGetPageContent();
  }

  Scaffold checkPendingGrabAndGetPageContent() {
    if (pendingGrab != null) getFullOperation(pendingGrab);
    return getPageContent();
  }

  Scaffold getPageContent() {
    var center = MapUtilities.computeCentroid(List<Marker>.of(markers.values));
    var map = GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
      initialCameraPosition: CameraPosition(
          target: center,
          zoom: MapUtilities.getViewCircleZoomLevel(
              center, List<Marker>.of(markers.values))),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedOperation == null
            ? 'Wasabee - Map'
            : 'Wasabee - ${selectedOperation.name}'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : map,
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

  doSelectOperationThing(Ops operation) {
    print('setting pending grab');
    operation.isSelected = true;
    this.pendingGrab = operation;
    this.selectedOperation = operation;
  }

  doInitialLoadThings() async {
    if (operationList.length > 0) {
      var foundOperation = await checkForSelectedOp(operationList);
      if (foundOperation == null) {
        print('FOUND operation is null!');
        doSelectOperationThing(operationList.first);
      } else {
        doSelectOperationThing(foundOperation);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<Ops> checkForSelectedOp(List<Ops> operationList) async {
    var selectedOpId = await LocalStorageUtils.getSelectedOpId();
    if (selectedOpId != null) {
      Ops foundOperation;
      for (var listOp in operationList) {
        if (listOp.iD == selectedOpId) foundOperation = listOp;
      }

      return foundOperation;
    } else {
      return null;
    }
  }

  getFullOperation(Ops op) async {
    isLoading = true;
    pendingGrab = null;
    try {
      var url = "${UrlManager.FULL_OPERATION_URL}${op.iD}";
      NetworkCalls.doNetworkCall(
          url, Map<String, String>(), gotOperation, false, NetWorkCallType.GET);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  gotOperation(response) async {
    try {
      var operation = OperationFullResponse.fromJson(json.decode(response));
      markers.clear();
      polylines.clear();
      populateAnchors(operation);
      populateLinks(operation);
      populateTargets(operation);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  title: MyApp.APP_TITLE,
                )),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  populateTargets(OperationFullResponse operation) async {
    if (operation.markers != null)
      for (var target in operation.markers) {
        final MarkerId targetId = MarkerId(target.iD);
        final Portal portal = operation.getPortalFromID(target.portalId);
        final Marker marker = Marker(
            markerId: targetId,
            icon: await target.getIcon(),
            position: LatLng(
              double.parse(portal.lat),
              double.parse(portal.lng),
            ),
            infoWindow: InfoWindow(
              title: portal.name,
              snippet: target.getMarkerTitle(portal.name),
              onTap: () {
                _onTargetTapped(targetId);
              },
            ));
        markers[targetId] = marker;
      }
  }

  _onTargetTapped(MarkerId targetId) {
    print('Tapped Target: ${targetId.value}');
  }

  populateAnchors(OperationFullResponse operation) async {
    for (var anchor in operation.anchors) {
      final MarkerId markerId = MarkerId(anchor);
      final Portal portal = operation.getPortalFromID(anchor);
      final Marker marker = Marker(
        markerId: markerId,
        icon: await this.selectedOperation.getIconFromColor(context),
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
    }
  }

  _onMarkerTapped(MarkerId markerId) {
    print('Tapped Marker: ${markerId.value}');
  }

  populateLinks(OperationFullResponse operation) {
    var lineWidth = 5;
    if (Platform.isIOS) lineWidth = 2;
    for (var link in operation.links) {
      final PolylineId polylineId = PolylineId(link.iD);
      final Portal fromPortal = operation.getPortalFromID(link.fromPortalId);
      final Portal toPortal = operation.getPortalFromID(link.toPortalId);
      final List<LatLng> points = <LatLng>[];
      points.add(LatLng(double.parse(fromPortal.lat), double.parse(fromPortal.lng)));
      points.add(LatLng(double.parse(toPortal.lat), double.parse(toPortal.lng)));
      final Polyline polyline = Polyline(
        geodesic: true,
        polylineId: polylineId,
        consumeTapEvents: true,
        color: this.selectedOperation.getLinkColor(),
        width: lineWidth,
        points: points,
        onTap: () {
          _onPolylineTapped(polylineId);
        },
      );
      polylines[polylineId] = polyline;
    }
  }

  void _onPolylineTapped(PolylineId polylineId) {
    print('Tapped Polyline: ${polylineId.value}');
  }

  List<Widget> getDrawerElements() {
    if (operationList == null || operationList.isEmpty) {
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

  tappedOp(Ops op, List<Ops> operationList) async {
    await LocalStorageUtils.storeSelectedOpId(op.iD);
    setState(() {
      doSelectOperationThing(op);
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
