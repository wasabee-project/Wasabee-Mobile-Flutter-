import 'package:wasabee/network/responses/meResponse.dart';

class TeamUtils {
  static const TEAM_STATE_OFF = 'Off';
  static const TEAM_STATE_ON = 'On';

  static int getCountOfActive(List<Team> teamList) {
    return getActiveList(teamList).length;
  }

  static List<Team> getActiveList(List<Team> teamList) {
    return teamList == null
        ? List<Team>()
        : teamList.where((i) => i.state == TEAM_STATE_ON).toList();
  }

  static int getCountOfInactive(List<Team> teamList) {
    return getInactiveList(teamList).length;
  }

  static List<Team> getInactiveList(List<Team> teamList) {
    return teamList == null
        ? List<Team>()
        : teamList.where((i) => i.state == TEAM_STATE_OFF).toList();
  }
}
