import 'package:wasabee/classutils/team.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/pages/teamspage/teamfiltermanager.dart';
import 'package:wasabee/pages/teamspage/teamsortdialog.dart';

class TeamListViewModel {
  String teamId;
  String titleString;
  String teamName;
  String teamState;
  bool isEnabled;
  bool isOwned;

  TeamListViewModel(
      {this.teamId,
      this.titleString,
      this.teamName,
      this.teamState,
      this.isEnabled,
      this.isOwned});

  static List<TeamListViewModel> fromTeamData(
      List<Team> teamList,
      List<Team> ownedTeamList,
      TeamSortType sortType,
      TeamFilterType filterType) {
    var listOfVM = List<TeamListViewModel>();
    if (teamList != null && teamList.length > 0) {
      for (var team in teamList) {
        listOfVM.add(TeamListViewModel(
            teamId: team.iD,
            titleString: '${team.name}',
            teamName: team.name,
            teamState: team.state,
            isEnabled: team.state == TeamUtils.TEAM_STATE_ON,
            isOwned: isTeamOwned(team, ownedTeamList)));
      }
    }
    listOfVM = TeamFilterManager.getFilteredTeams(listOfVM, filterType);
    listOfVM = sortTeamVMsByName(listOfVM);
    listOfVM = sortFromType(sortType, listOfVM);
    return listOfVM;
  }

  static bool isTeamOwned(Team team, List<Team> ownedTeamList) {
    var foundTeam = false;
    for (var ownedTeam in ownedTeamList) {
      if (team.iD == ownedTeam.iD)
        foundTeam = true;
    }
    return foundTeam;
  }

  static List<TeamListViewModel> sortFromType(
      TeamSortType type, List<TeamListViewModel> list) {
    switch (type) {
      case TeamSortType.AlphaName:
        list = sortTeamVMsByName(list);
        break;
      case TeamSortType.CurrentState:
        list = sortTeamVMsByState(list);
        break;
      case TeamSortType.Owned:
        list = sortTeamVMsByOwned(list);
        break;
    }
    return list;
  }

  static List<TeamListViewModel> sortTeamVMsByName(
      List<TeamListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) =>
        a.titleString.toLowerCase().compareTo(b.titleString.toLowerCase()));
    return listOfTargets;
  }

  static List<TeamListViewModel> sortTeamVMsByState(
      List<TeamListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) =>
        b.teamState.toLowerCase().compareTo(a.teamState.toLowerCase()));
    return listOfTargets;
  }

  static List<TeamListViewModel> sortTeamVMsByOwned(
      List<TeamListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) =>
        a.isOwned.toString().compareTo(b.isOwned.toString()));
    return listOfTargets;
  }
}
