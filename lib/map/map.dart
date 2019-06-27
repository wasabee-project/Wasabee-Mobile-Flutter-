import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:flutter/foundation.dart';
import '../network/networkcalls.dart';

class MapPage extends StatefulWidget {
  final List<Ops> ops;

  MapPage({Key key, @required this.ops}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState(ops);
}

class _MapPageState extends State<MapPage> {
  var isLoading = false;
  var pendingGrab;
  Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(32.7766642, -96.7969879);
  List<Ops> operationList = List();
  _MapPageState(List<Ops> ops) {
    this.operationList = ops;
    if (this.operationList.length > 0) {
      this.pendingGrab = operationList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pendingGrab != null) getFullOperation(pendingGrab);
    return MaterialApp(
      home: Scaffold(
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
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
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
    print("RESPONSE! -> $response");
    setState(() {
      isLoading = false;
    });
  }

  List<Widget> getDrawerElements() {
    print("Operation List Size = " + operationList.length.toString());
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
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ));
      }
      return listOfElements;
    }
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    var currentLocation = LocationData;

    // var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   currentLocation = await location.getLocation();
    // } on PlatformException catch (e) {
    //   if (e.code == 'PERMISSION_DENIED') {
    //     error = 'Permission denied';
    //   }
    //   currentLocation = null;
    // }
  }
}
