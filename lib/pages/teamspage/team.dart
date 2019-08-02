import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamPage extends StatefulWidget {
  TeamPage({Key key}) : super(key: key);

  @override
  TeamPageState createState() => TeamPageState();
}

class TeamPageState extends State<TeamPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Teams"),
        ),
        body: Center(child: Text('TeamPage')));
  }
}
