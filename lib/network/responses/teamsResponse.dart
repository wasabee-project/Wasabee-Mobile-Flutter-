class FullTeam {
  String name;
  String id;
  List<Agent> agents;

  FullTeam({this.name, this.id, this.agents});

  FullTeam.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    if (json['agents'] != null) {
      agents = new List<Agent>();
      json['agents'].forEach((v) {
        agents.add(new Agent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    if (this.agents != null) {
      data['agents'] = this.agents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agent {
  String id;
  String name;
  int level;
  String enlid;
  String pic;
  bool vverified;
  bool blacklisted;
  String color;
  bool state;
  double lat;
  double lng;
  String date;

  Agent(
      {this.id,
      this.name,
      this.level,
      this.enlid,
      this.pic,
      this.vverified,
      this.blacklisted,
      this.color,
      this.state,
      this.lat,
      this.lng,
      this.date});

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    enlid = json['enlid'];
    pic = json['pic'];
    vverified = json['Vverified'];
    blacklisted = json['blacklisted'];
    color = json['color'];
    state = json['state'];
    lat = json['lat'];
    lng = json['lng'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['level'] = this.level;
    data['enlid'] = this.enlid;
    data['pic'] = this.pic;
    data['Vverified'] = this.vverified;
    data['blacklisted'] = this.blacklisted;
    data['color'] = this.color;
    data['state'] = this.state;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['date'] = this.date;
    return data;
  }
}