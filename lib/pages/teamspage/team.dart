import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wasabee/network/cookies.dart';
import 'package:wasabee/network/networkcalls.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/network/urlmanager.dart';
import 'package:wasabee/pages/teamspage/teamlistvm.dart';
import 'package:wasabee/pages/teamspage/teamsortdialog.dart';
import 'package:wasabee/storage/localstorage.dart';

class TeamPage extends StatefulWidget {
  TeamPage({Key key, this.teamSortDropDownValue, this.vmList})
      : super(key: key);
  final TeamSortType teamSortDropDownValue;
  final List<TeamListViewModel> vmList;

  @override
  TeamPageState createState() => TeamPageState(teamSortDropDownValue, vmList);
}

class TeamPageState extends State<TeamPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TeamSortType teamSortDropDownValue;
  List<TeamListViewModel> vmList;
  bool isLoading = true;

  TeamPageState(
      TeamSortType teamSortDropDownValue, List<TeamListViewModel> vmList) {
    this.teamSortDropDownValue = teamSortDropDownValue;
    this.vmList = vmList;
  }

  @override
  void initState() {
    getTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var title = "Teams";
    return isLoading == true
        ? Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                )))
        : Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(child: Text('TeamPage')));
  }

  setTeamSortDropdownValue(TeamSortType value) {
    setState(() {
      teamSortDropDownValue = value;
    });
  }

  getTeams() {
    var url = UrlManager.FULL_ME_URL;
    try {
      NetworkCalls.doNetworkCall(url, Map<String, String>(), finishedGetTeams,
          true, NetWorkCallType.GET);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void finishedGetTeams(String response) async {
    try {
      var meResponse = MeResponse.fromJson(json.decode(response));
      var googleId = meResponse.googleID;
      if (googleId != null) await LocalStorageUtils.storeGoogleId(googleId);
      var teamSortType = await LocalStorageUtils.getTeamSort();
      var useImperialUnits = await LocalStorageUtils.getUseImperialUnits();
      var teamList = meResponse.teams;
      var ownedTeamList = meResponse.ownedTeams;
      print('$response');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      await CookieUtils.clearAllCookies();
      setState(() {
        isLoading = false;
      });
      print("Exception In getTeams -> $e");
    }
  }
}
