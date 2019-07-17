import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/classutils/operation.dart';
import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:geolocator/geolocator.dart';
import '../location/locationhelper.dart';
import '../network/networkcalls.dart';
import '../network/urlmanager.dart';
import '../storage/localstorage.dart';
import '../map/utilities.dart';
import '../network/responses/teamsResponse.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  final List<Op> ops;

  MapPage({Key key, @required this.ops}) : super(key: key);

  @override
  MapPageState createState() => MapPageState(ops);
}

class MapPageState extends State<MapPage> {
  var firstLoad = true;
  var isLoading = true;
  var sharingLocation = false;
  var pendingGrab;
  Op selectedOperation;
  Operation loadedOperation;
  GoogleMapController _controller;
  GoogleMap mapView;
  List<Op> operationList = List();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> targets = <MarkerId, Marker>{};
  MapMarkerBitmapBank bitmapBank = MapMarkerBitmapBank();
  LatLngBounds _visibleRegion;

  MapPageState(List<Op> ops) {
    this.operationList = ops;
  }

  @override
  void initState() {
    LocalStorageUtils.getIsLocationSharing().then((bool isLocationSharing) {
      sharingLocation = isLocationSharing;
      sendLocationIfSharing();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad == true) {
      firstLoad = false;
      doInitialLoadThings();
    }
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Map'),
                    Tab(text: 'Alerts'),
                    Tab(text: 'Links'),
                  ],
                ),
                title: Text(selectedOperation == null
                    ? 'Wasabee - Map'
                    : '${selectedOperation.name}'),
                actions: loadedOperation == null
                    ? null
                    : <Widget>[
                        // action button
                        // IconButton(
                        //   icon: Icon(Icons.settings),
                        //   onPressed: () {
                        //     //TODO add settings page nav here
                        //     print('settings tapped');
                        //   },
                        // ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            doRefresh(selectedOperation, true);
                          },
                        )
                      ],
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : getPageContent(),
                  Icon(Icons.add_alert),
                  Icon(Icons.link),
                ],
              ),
              drawer: isLoading
                  ? null
                  : Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: getDrawerElements(),
                      ),
                    ),
            ),
          );
  }

  Scaffold getPageContent() {
    populateMapView();
    return Scaffold(
      body: mapView,
    );
  }

  populateMapView() {
    var center = _visibleRegion == null
        ? MapUtilities.computeCentroid(List<Marker>.of(markers.values))
        : MapUtilities.getCenterFromBounds(_visibleRegion);
    var bounds = _visibleRegion == null
        ? MapUtilities.getBounds(List<Marker>.of(markers.values))
        : _visibleRegion;
    var fromExistingLocation = _visibleRegion != null;
    mapView = GoogleMap(
      onMapCreated: onMapCreated,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
      initialCameraPosition: CameraPosition(
          target: center,
          zoom: MapUtilities.getViewCircleZoomLevel(
              center, bounds, fromExistingLocation)),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  updateVisibleRegion() async {
    if (_controller != null) {
      final LatLngBounds visibleRegion = await _controller.getVisibleRegion();
      _visibleRegion = visibleRegion;
    }
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
      listOfElements.add(getDrawerHeader());
      listOfElements.add(getShareLocationViews());
      listOfElements.add(getRefreshOpListButton());
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

  Widget getDrawerHeader() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Text(
            'Wasabee Operations',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
          Center(
            child: Container(
                margin: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.white,
                  child: new Image.asset(
                    'assets/images/wasabee.png',
                    width: 70.0,
                    height: 70.0,
                    fit: BoxFit.cover,
                  ),
                )),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }

  Widget getShareLocationViews() {
    return Center(
        child: Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sharing Location",
                  style: TextStyle(color: Colors.black),
                ),
                Checkbox(
                  value: sharingLocation,
                  onChanged: (value) {
                    setState(() {
                      print('VALUE -> $value');
                      LocalStorageUtils.storeIsLocationSharing(value)
                          .then((any) {
                        sendLocationIfSharing();
                      });
                      sharingLocation = value;
                    });
                  },
                )
              ],
            )));
  }

  Widget getRefreshOpListButton() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RaisedButton(
          color: Colors.green,
          child: Text(
            'Refresh Op List',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            tappedRefreshAllOps();
          },
        ));
  }

  //TODO do this whenever the map is updated.
  sendLocationIfSharing() {
    if (sharingLocation) {
      LocationHelper.locateUser().then((Position userPosition) {
        if (userPosition != null) {
          try {
            var url =
                "${UrlManager.FULL_LAT_LNG_URL}lat=${userPosition.latitude}&lon=${userPosition.longitude}";
            NetworkCalls.doNetworkCall(url, Map<String, String>(), gotLocation,
                false, NetWorkCallType.GET);
          } catch (e) {
            print(e);
          }
        }
      });
    }
  }

  gotLocation(String response) {
    print("gotLocation -> $response");
  }

  tappedRefreshAllOps() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OperationUtils.getRefreshOpListDialog(context);
      },
    );
  }

  doRefresh(Op op, bool resetVisibleRegion) async {
    if (resetVisibleRegion)
      _visibleRegion = null;
    setState(() {
      doSelectOperationThing(op);
      pendingGrab = op;
    });
  }

  doSelectOperationThing(Op operation) {
    print('setting pending grab');
    operation.isSelected = true;
    this.pendingGrab = operation;
    this.selectedOperation = operation;
    if (pendingGrab != null) getFullOperation(pendingGrab);
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
  }

  Future<Op> checkForSelectedOp(List<Op> operationList) async {
    var selectedOpId = await LocalStorageUtils.getSelectedOpId();
    if (selectedOpId != null) {
      Op foundOperation;
      for (var listOp in operationList) {
        if (listOp.iD == selectedOpId) foundOperation = listOp;
      }

      return foundOperation;
    } else {
      return null;
    }
  }

  getFullOperation(Op op) async {
    isLoading = true;
    pendingGrab = null;
    try {
      var url = "${UrlManager.FULL_OPERATION_URL}${op.iD}";
      NetworkCalls.doNetworkCall(
          url, Map<String, String>(), gotOperation, false, NetWorkCallType.GET);
    } catch (e) {
      setIsNotLoading();
      print(e);
    }
  }

  gotOperation(String response) async {
    try {
      var operation = Operation.fromJson(json.decode(response));
      loadedOperation = operation;
      await populateEverything();

      var url = "${UrlManager.FULL_GET_TEAM_URL}${selectedOperation.teamID}";
      NetworkCalls.doNetworkCall(
          url, Map<String, String>(), gotTeam, false, NetWorkCallType.GET);
    } catch (e) {
      parsingOperationFailed();
      setIsNotLoading();
    }
  }

  populateEverything() async {
    markers.clear();
    polylines.clear();
    populateBank();
    bitmapBank.bank.clear();
    populateAnchors(loadedOperation);
    populateLinks(loadedOperation);
    populateTargets(loadedOperation);
  }

  finishedTargetActionCall(String response) {
    doRefresh(selectedOperation, false);
    //gotOperation(response);
  }

  gotTeam(String response) {
    var team = FullTeam.fromJson(json.decode(response));
    populateTeamMembers(team.agents);
    setIsNotLoading();
  }

  parsingOperationFailed() async {
    var operationName =
        selectedOperation != null ? " '${selectedOperation.name}'" : "";
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OperationUtils.getParsingOperationFailedDialog(
            context, operationName);
      },
    );
  }

  populateTargets(Operation operation) async {
    if (operation.markers != null) {
      populateBank();
      var googleId = await LocalStorageUtils.getGoogleId();
      for (var target in operation.markers) {
        final MarkerId targetId = MarkerId(target.iD);
        final Portal portal =
            OperationUtils.getPortalFromID(target.portalId, operation);
        final Marker marker = Marker(
            markerId: targetId,
            icon: await bitmapBank.getIconFromBank(
                target.type, context, target, googleId),
            position: LatLng(
              double.parse(portal.lat),
              double.parse(portal.lng),
            ),
            infoWindow: InfoWindow(
              title: portal.name,
              snippet: TargetUtils.getMarkerTitle(portal.name, target),
              onTap: () {
                _onTargetInfoWindowTapped(target, portal, targetId);
              },
            ),
            onTap: () {
              _onTargetTapped(targetId);
            });
        markers[targetId] = marker;
      }
    }
  }

  populateAnchors(Operation operation) async {
    if (operation.anchors != null) {
      populateBank();
      for (var anchor in operation.anchors) {
        final MarkerId markerId = MarkerId(anchor);
        final Portal portal = OperationUtils.getPortalFromID(anchor, operation);
        final Marker marker = Marker(
          markerId: markerId,
          icon: await bitmapBank.getIconFromBank(
              operation.color, context, null, null),
          position: LatLng(
            double.parse(portal.lat),
            double.parse(portal.lng),
          ),
          infoWindow: InfoWindow(
              title: portal.name,
              snippet:
                  'Links: ${OperationUtils.getLinksForPortalId(portal.id, operation).length}',
              onTap: _onAnchorInfoWindowTapped(markerId)),
          onTap: () {
            _onAnchorTapped(markerId);
          },
        );
        markers[markerId] = marker;
      }
    }
  }

  populateTeamMembers(List<Agent> agents) async {
    if (agents != null) {
      populateBank();
      for (var agent in agents) {
        if (agent.lat != null && agent.lng != null) {
          final MarkerId markerId = MarkerId("agent_${agent.name}");
          final Marker marker = Marker(
            markerId: markerId,
            icon: await bitmapBank.getIconFromBank(
                "agent_${agent.name}", context, null, null),
            position: LatLng(
              agent.lat,
              agent.lng,
            ),
            infoWindow: InfoWindow(
                title: agent.name,
                snippet: 'Last Updated: ${agent.date}',
                onTap: _onAgentInfoWindowTapped(markerId)),
            onTap: () {
              _onAgentTapped(markerId);
            },
          );
          markers[markerId] = marker;
        }
      }
    }
  }

  populateLinks(Operation operation) {
    var lineWidth = 5;
    if (Platform.isIOS) lineWidth = 2;
    if (operation.links != null) {
      populateBank();
      for (var link in operation.links) {
        final PolylineId polylineId = PolylineId(link.iD);
        final Portal fromPortal =
            OperationUtils.getPortalFromID(link.fromPortalId, operation);
        final Portal toPortal =
            OperationUtils.getPortalFromID(link.toPortalId, operation);
        final List<LatLng> points = <LatLng>[];
        points.add(
            LatLng(double.parse(fromPortal.lat), double.parse(fromPortal.lng)));
        points.add(
            LatLng(double.parse(toPortal.lat), double.parse(toPortal.lng)));
        final Polyline polyline = Polyline(
          geodesic: true,
          polylineId: polylineId,
          consumeTapEvents: true,
          color: OperationUtils.getLinkColor(this.selectedOperation),
          width: lineWidth,
          points: points,
          onTap: () {
            _onPolylineTapped(polylineId);
          },
        );
        polylines[polylineId] = polyline;
      }
    }
  }

  _onTargetInfoWindowTapped(Target target, Portal portal, MarkerId markerId) {
    //print('Tapped MarkerInfoWindow: ${markerId.value}');
    LocalStorageUtils.getGoogleId().then((googleId) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TargetUtils.getTargetInfoAlert(
              context, portal, target, googleId, selectedOperation.iD, this);
        },
      );
    });
  }

  _onTargetTapped(MarkerId targetId) {
    //print('Tapped Target: ${targetId.value}');
  }

  void _onPolylineTapped(PolylineId polylineId) {
    //print('Tapped Polyline: ${polylineId.value}');
  }

  _onAnchorInfoWindowTapped(MarkerId markerId) {
    //print('Tapped AnchorInfoWindow: ${markerId.value}');
  }

  _onAnchorTapped(MarkerId markerId) {
    //print('Tapped Marker: ${markerId.value}');
  }

  _onAgentInfoWindowTapped(MarkerId markerId) {
    //print('Tapped AgentInfoWindow: ${markerId.value}');
  }

  _onAgentTapped(MarkerId markerId) {
    //print('Tapped Agent: ${markerId.value}');
  }

  populateBank() {
    if (bitmapBank == null) bitmapBank = MapMarkerBitmapBank();
  }

  tappedOp(Op op, List<Op> operationList) async {
    await LocalStorageUtils.storeSelectedOpId(op.iD);
    setState(() {
      doRefresh(op, true);
      for (var ops in operationList) {
        if (op.iD == ops.iD)
          ops.isSelected = true;
        else
          ops.isSelected = false;
      }
    });
  }

  setIsLoading() {
    print('setting loading');
    setState(() {
      isLoading = true;
    });
  }

  setIsNotLoading() {
    print('setting not loading');
    setState(() {
      isLoading = false;
    });
  }
}
