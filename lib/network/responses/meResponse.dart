import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/map/utilities.dart';

class MeResponse {
  String googleID;
  String ingressName;
  int level;
  String locationKey;
  String ownTracksPW;
  bool vVerified;
  bool vBlacklisted;
  String vid;
  String ownTracksJSON;
  bool rocksVerified;
  bool rAID;
  bool rISC;
  List<OwnedTeams> ownedTeams;
  List<Teams> teams;
  List<Ops> ops;
  List<OwnedOps> ownedOps;
  Telegram telegram;
  List<Assignments> assignments;

  MeResponse(
      {this.googleID,
      this.ingressName,
      this.level,
      this.locationKey,
      this.ownTracksPW,
      this.vVerified,
      this.vBlacklisted,
      this.vid,
      this.ownTracksJSON,
      this.rocksVerified,
      this.rAID,
      this.rISC,
      this.ownedTeams,
      this.teams,
      this.ops,
      this.ownedOps,
      this.telegram,
      this.assignments});

  MeResponse.fromJson(Map<String, dynamic> json) {
    googleID = json['GoogleID'];
    ingressName = json['IngressName'];
    level = json['Level'];
    locationKey = json['LocationKey'];
    ownTracksPW = json['OwnTracksPW'];
    vVerified = json['VVerified'];
    vBlacklisted = json['VBlacklisted'];
    vid = json['Vid'];
    ownTracksJSON = json['OwnTracksJSON'];
    rocksVerified = json['RocksVerified'];
    rAID = json['RAID'];
    rISC = json['RISC'];
    if (json['OwnedTeams'] != null) {
      ownedTeams = new List<OwnedTeams>();
      json['OwnedTeams'].forEach((v) {
        ownedTeams.add(new OwnedTeams.fromJson(v));
      });
    }
    if (json['Teams'] != null) {
      teams = new List<Teams>();
      json['Teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    if (json['Ops'] != null) {
      ops = new List<Ops>();
      json['Ops'].forEach((v) {
        ops.add(new Ops.fromJson(v));
      });
    }
    if (json['OwnedOps'] != null) {
      ownedOps = new List<OwnedOps>();
      json['OwnedOps'].forEach((v) {
        ownedOps.add(new OwnedOps.fromJson(v));
      });
    }
    telegram = json['Telegram'] != null
        ? new Telegram.fromJson(json['Telegram'])
        : null;
    if (json['Assignments'] != null) {
      assignments = new List<Assignments>();
      json['Assignments'].forEach((v) {
        assignments.add(new Assignments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GoogleID'] = this.googleID;
    data['IngressName'] = this.ingressName;
    data['Level'] = this.level;
    data['LocationKey'] = this.locationKey;
    data['OwnTracksPW'] = this.ownTracksPW;
    data['VVerified'] = this.vVerified;
    data['VBlacklisted'] = this.vBlacklisted;
    data['Vid'] = this.vid;
    data['OwnTracksJSON'] = this.ownTracksJSON;
    data['RocksVerified'] = this.rocksVerified;
    data['RAID'] = this.rAID;
    data['RISC'] = this.rISC;
    if (this.ownedTeams != null) {
      data['OwnedTeams'] = this.ownedTeams.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['Teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    if (this.ops != null) {
      data['Ops'] = this.ops.map((v) => v.toJson()).toList();
    }
    if (this.ownedOps != null) {
      data['OwnedOps'] = this.ownedOps.map((v) => v.toJson()).toList();
    }
    if (this.telegram != null) {
      data['Telegram'] = this.telegram.toJson();
    }
    if (this.assignments != null) {
      data['Assignments'] = this.assignments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OwnedTeams {
  String iD;
  String name;
  String rocksComm;
  String rocksKey;

  OwnedTeams({this.iD, this.name, this.rocksComm, this.rocksKey});

  OwnedTeams.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    rocksComm = json['RocksComm'];
    rocksKey = json['RocksKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['RocksComm'] = this.rocksComm;
    data['RocksKey'] = this.rocksKey;
    return data;
  }
}

class Teams {
  String iD;
  String name;
  String state;
  String rocksComm;

  Teams({this.iD, this.name, this.state, this.rocksComm});

  Teams.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    state = json['State'];
    rocksComm = json['RocksComm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['State'] = this.state;
    data['RocksComm'] = this.rocksComm;
    return data;
  }
}

class Ops {
  String iD;
  String name;
  String color;
  String teamName;
  String teamID;
  bool isSelected = false;

  Ops({this.iD, this.name, this.color, this.teamName, this.teamID});

  Ops.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
    teamName = json['TeamName'];
    teamID = json['TeamID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['TeamName'] = this.teamName;
    data['TeamID'] = this.teamID;
    return data;
  }

  Color getLinkColor() {
    String hexString = "";
    switch (this.color) {
      case "groupa":
        hexString = 'ff6600';
        break;
      case "groupb":
        hexString = 'ff9900';
        break;
      case "groupc":
        hexString = 'BB9900';
        break;
      case "groupd":
        hexString = 'bb22cc';
        break;
      case "groupe":
        hexString = '33cccc';
        break;
      case "groupf":
        hexString = 'ff55ff';
        break;
    }
    return HexColor(hexString);
  }

  Future<BitmapDescriptor> getIconFromColor(BuildContext context) async {
    String path = 'assets/icons/groupa_2.bmp';
    switch (this.color) {
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
    final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
    return BitmapDescriptor.fromAssetImage(imageConfiguration, path);
  }
}

class OwnedOps {
  String iD;
  String name;
  String color;
  String teamName;
  String teamID;

  OwnedOps({this.iD, this.name, this.color, this.teamName, this.teamID});

  OwnedOps.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    color = json['Color'];
    teamName = json['TeamName'];
    teamID = json['TeamID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['TeamName'] = this.teamName;
    data['TeamID'] = this.teamID;
    return data;
  }
}

class Telegram {
  String userName;
  int iD;
  bool verified;
  String authtoken;

  Telegram({this.userName, this.iD, this.verified, this.authtoken});

  Telegram.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    iD = json['ID'];
    verified = json['Verified'];
    authtoken = json['Authtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['ID'] = this.iD;
    data['Verified'] = this.verified;
    data['Authtoken'] = this.authtoken;
    return data;
  }
}

class Assignments {
  String opID;
  String operationName;
  String type;

  Assignments({this.opID, this.operationName, this.type});

  Assignments.fromJson(Map<String, dynamic> json) {
    opID = json['OpID'];
    operationName = json['OperationName'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OpID'] = this.opID;
    data['OperationName'] = this.operationName;
    data['Type'] = this.type;
    return data;
  }
}
