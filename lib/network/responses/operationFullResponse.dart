import 'package:google_maps_flutter/google_maps_flutter.dart';

class OperationFullResponse {
  String iD;
  String name;
  String creator;
  String color;
  List<Portal> opportals;
  List<String> anchors;
  List<Links> links;
  List<Markers> markers;
  String teamid;
  String modified;
  String comment;
  Null keysonhand;
  String fetched;

  OperationFullResponse(
      {this.iD,
      this.name,
      this.creator,
      this.color,
      this.opportals,
      this.anchors,
      this.links,
      this.markers,
      this.teamid,
      this.modified,
      this.comment,
      this.keysonhand,
      this.fetched});

  OperationFullResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    creator = json['creator'];
    color = json['color'];
    if (json['opportals'] != null) {
      opportals = new List<Portal>();
      json['opportals'].forEach((v) {
        opportals.add(new Portal.fromJson(v));
      });
    }
    anchors = json['anchors'].cast<String>();
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    if (json['markers'] != null) {
      markers = new List<Markers>();
      json['markers'].forEach((v) {
        markers.add(new Markers.fromJson(v));
      });
    }
    teamid = json['teamid'];
    modified = json['modified'];
    comment = json['comment'];
    keysonhand = json['keysonhand'];
    fetched = json['fetched'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['name'] = this.name;
    data['creator'] = this.creator;
    data['color'] = this.color;
    if (this.opportals != null) {
      data['opportals'] = this.opportals.map((v) => v.toJson()).toList();
    }
    data['anchors'] = this.anchors;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    if (this.markers != null) {
      data['markers'] = this.markers.map((v) => v.toJson()).toList();
    }
    data['teamid'] = this.teamid;
    data['modified'] = this.modified;
    data['comment'] = this.comment;
    data['keysonhand'] = this.keysonhand;
    data['fetched'] = this.fetched;
    return data;
  }

  Portal getPortalFromID(String id) {
    for (var portal in this.opportals) {
      if (portal.id == id) return portal;
    }
    return null;
  }
}

class Portal {
  String id;
  String name;
  String lat;
  String lng;
  String comment;
  String hardness;

  Portal({this.id, this.name, this.lat, this.lng, this.comment, this.hardness});

  Portal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    comment = json['comment'];
    hardness = json['hardness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['comment'] = this.comment;
    data['hardness'] = this.hardness;
    return data;
  }
}

class Links {
  String iD;
  String fromPortalId;
  String toPortalId;
  String description;
  String assignedTo;
  int throwOrderPos;

  Links(
      {this.iD,
      this.fromPortalId,
      this.toPortalId,
      this.description,
      this.assignedTo,
      this.throwOrderPos});

  Links.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fromPortalId = json['fromPortalId'];
    toPortalId = json['toPortalId'];
    description = json['description'];
    assignedTo = json['assignedTo'];
    throwOrderPos = json['throwOrderPos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['fromPortalId'] = this.fromPortalId;
    data['toPortalId'] = this.toPortalId;
    data['description'] = this.description;
    data['assignedTo'] = this.assignedTo;
    data['throwOrderPos'] = this.throwOrderPos;
    return data;
  }
}

class Markers {
  static const DestroyPortalAlert = "DestroyPortalAlert";
  static const UseVirusPortalAlert = "UseVirusPortalAlert";
  static const LetDecayPortalAlert = "LetDecayPortalAlert";

  String iD;
  String portalId;
  String type;
  String comment;
  String assignedTo;
  bool complete;

  Markers(
      {this.iD,
      this.portalId,
      this.type,
      this.comment,
      this.assignedTo,
      this.complete});

  Markers.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    portalId = json['portalId'];
    type = json['type'];
    comment = json['comment'];
    assignedTo = json['assignedTo'];
    complete = json['complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['portalId'] = this.portalId;
    data['type'] = this.type;
    data['comment'] = this.comment;
    data['assignedTo'] = this.assignedTo;
    data['complete'] = this.complete;
    return data;
  }

  Future<BitmapDescriptor> getIcon() async {
    String path = 'assets/icons/unknown.bmp';
    switch (this.type) {
      case LetDecayPortalAlert:
        path = 'assets/icons/decay.bmp';
        break;
      case DestroyPortalAlert:
        path = 'assets/icons/destroy.bmp';
        break;
      case UseVirusPortalAlert:
        path = 'assets/icons/virus.bmp';
        break;
    }
    return BitmapDescriptor.fromAsset(path);
  }

  getMarkerTitle(String portalName) {
    var title = "";
    switch (this.type) {
      case DestroyPortalAlert:
        title = "Destroy - ";
        break;
      case UseVirusPortalAlert:
        title = "Virus - ";
        break;
      case LetDecayPortalAlert:
        title = "Let Decay - ";
        break;
    }
    title = "$title$portalName";
    return title;
  }
}
