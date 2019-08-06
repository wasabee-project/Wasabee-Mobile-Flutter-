import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/pages/teamspage/teamsortdialog.dart';

class TeamListViewModel {
  String teamId;
  String titleString;
  String teamName;
  String teamState;

  TeamListViewModel(
      {this.teamId, this.titleString, this.teamName, this.teamState});

  static List<TeamListViewModel> fromTeamData(
      List<Team> teamList, List<Team> ownedTeamList, TeamSortType sortType, bool useImperialUnits) {
    var listOfVM = List<TeamListViewModel>();
    if (teamList != null && teamList.length > 0)
      for (var team in teamList) {
        listOfVM.add(TeamListViewModel(
            teamId: team.iD,
            titleString: '${team.name}',
            teamName: team.name,
            teamState: team.state));
      }
    listOfVM = sortTeamVMsByName(listOfVM);
    listOfVM = sortFromType(sortType, listOfVM);
    return listOfVM;
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
        a.titleString.toLowerCase().compareTo(b.titleString.toLowerCase()));
    return listOfTargets;
  }
}
