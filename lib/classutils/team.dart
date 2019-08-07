import 'package:wasabee/pages/teamspage/teamlistvm.dart';

class TeamUtils {
  static const TEAM_STATE_OFF = 'Off';
  static const TEAM_STATE_ON = 'On';

  static int getCountOfActive(List<TeamListViewModel> teamList) {
    return getActiveList(teamList).length;
  }

  static List<TeamListViewModel> getActiveList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_ON).toList();
  }

  static int getCountOfInactive(List<TeamListViewModel> teamList) {
    return getInactiveList(teamList).length;
  }

  static List<TeamListViewModel> getInactiveList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_OFF).toList();
  }

   static int getCountOfOwned(List<TeamListViewModel> teamList) {
    return getOwnedList(teamList).length;
  }

  static List<TeamListViewModel> getOwnedList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.isOwned == true).toList();
  }
}
