class Operation {
  String iD;
  String name;
  String creator;
  String color;
  List<Portal> opportals;
  List<String> anchors;
  List<Link> links;
  List<Target> markers;
  String teamid;
  String modified;
  String comment;
  List<KeyOnHand> keysonhand;
  String fetched;

  Operation(
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

  Operation.fromJson(Map<String, dynamic> json) {
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
      links = new List<Link>();
      json['links'].forEach((v) {
        links.add(new Link.fromJson(v));
      });
    }
    if (json['markers'] != null) {
      markers = new List<Target>();
      json['markers'].forEach((v) {
        markers.add(new Target.fromJson(v));
      });
    }
    teamid = json['teamid'];
    modified = json['modified'];
    comment = json['comment'];
    if (json['keysonhand'] != null) {
      keysonhand = new List<KeyOnHand>();
      json['keysonhand'].forEach((v) {
        keysonhand.add(new KeyOnHand.fromJson(v));
      });
    }
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

class Link {
  String iD;
  String fromPortalId;
  String toPortalId;
  String description;
  String assignedTo;
  int throwOrderPos;

  Link(
      {this.iD,
      this.fromPortalId,
      this.toPortalId,
      this.description,
      this.assignedTo,
      this.throwOrderPos});

  Link.fromJson(Map<String, dynamic> json) {
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

class Target {
  String iD;
  String portalId;
  String type;
  String comment;
  String assignedTo;
  String assignedNickname;
  String completedBy;
  String state;

  Target(
      {this.iD,
      this.portalId,
      this.type,
      this.comment,
      this.assignedTo,
      this.assignedNickname,
      this.completedBy,
      this.state});

  Target.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    portalId = json['portalId'];
    type = json['type'];
    comment = json['comment'];
    assignedTo = json['assignedTo'];
    assignedNickname = json['assignedNickname'];
    completedBy = json['completedBy'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['portalId'] = this.portalId;
    data['type'] = this.type;
    data['comment'] = this.comment;
    data['assignedTo'] = this.assignedTo;
    data['assignedNickname'] = this.assignedNickname;
    data['completedBy'] = this.completedBy;
    data['state'] = this.state;
    return data;
  }
}

class KeyOnHand {
  String portalId;
  String gid;
  int onhand;

  KeyOnHand({this.portalId, this.gid, this.onhand});

  KeyOnHand.fromJson(Map<String, dynamic> json) {
    portalId = json['portalId'];
    gid = json['gid'];
    onhand = json['onhand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['portalId'] = this.portalId;
    data['gid'] = this.gid;
    data['onhand'] = this.onhand;
    return data;
  }
}
