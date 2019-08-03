import 'package:wasabee/pages/teamspage/teamsortdialog.dart';

class TeamSortManager {
  static List<TeamSortType> getFilters() {
    var sortTypeList = List<TeamSortType>();
    sortTypeList.add(TeamSortType.AlphaName);
    sortTypeList.add(TeamSortType.CurrentState);
    return sortTypeList;
  }

  static String getDisplayStringFromEnum(TeamSortType type) {
    String displayString = "";
    switch (type) {
      case TeamSortType.AlphaName:
        displayString = "Team Name";
        break;
      case TeamSortType.CurrentState:
        displayString = "Current State";
        break;
    }
    return displayString;
  }
}
