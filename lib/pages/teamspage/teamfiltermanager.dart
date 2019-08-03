

import 'package:wasabee/classutils/team.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/pages/teamspage/teamsortdialog.dart';

class TeamFilterManager {
  static List<TeamFilterType> getFilters() {
    var filterTypeList = List<TeamFilterType>();
    filterTypeList.add(TeamFilterType.All);
    filterTypeList.add(TeamFilterType.Active);
    filterTypeList.add(TeamFilterType.Inactive);
    return filterTypeList;
  }

  static String getDisplayStringFromEnum(
      TeamFilterType type, List<Team> teamFilter, String googleId) {
    String displayString = "";
    switch (type) {
      case TeamFilterType.All:
        displayString = "All Teams";
        break;
      case TeamFilterType.Active:
        displayString = "Active Teams";
        break;
      case TeamFilterType.Inactive:
        displayString = "Inactive Teams";
        break;
    }
    return teamFilter == null
        ? displayString
        : "$displayString (${getCountFromTeamFilter(type, teamFilter, googleId)})";
  }

  static int getCountFromTeamFilter(
      TeamFilterType type, List<Team> teamFilter, String googleId) {
    int count = 0;
    switch (type) {
      case TeamFilterType.All:
        count = teamFilter.length;
        break;
      case TeamFilterType.Active:
        count = TeamUtils.getCountOfActive(teamFilter);
        break;
      case TeamFilterType.Inactive:
        count = TeamUtils.getCountOfInactive(teamFilter);
        break;
    }
    return count;
  }

  static TeamFilterType getFilterTypeAsString(String typeAsString) {
    for (TeamFilterType element in TeamFilterType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }

  static TeamSortType getSortTypeAsString(String typeAsString) {
    for (TeamSortType element in TeamSortType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }
}

enum TeamFilterType { All, Active, Inactive }
