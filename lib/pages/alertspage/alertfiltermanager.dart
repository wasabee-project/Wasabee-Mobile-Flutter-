import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/alertspage/alertsortdialog.dart';

class AlertFilterManager {
  static List<AlertFilterType> getFilters() {
    var filterTypeList = List<AlertFilterType>();
    filterTypeList.add(AlertFilterType.All);
    filterTypeList.add(AlertFilterType.Unassigned);
    filterTypeList.add(AlertFilterType.Mine);
    return filterTypeList;
  }

  static String getDisplayStringFromEnum(
      AlertFilterType type, List<Target> targetList, String googleId) {
    String displayString = "";
    switch (type) {
      case AlertFilterType.All:
        displayString = "All Alerts";
        break;
      case AlertFilterType.Unassigned:
        displayString = "Unassigned Alerts";
        break;
      case AlertFilterType.Mine:
        displayString = "My Alerts";
        break;
    }
    return targetList == null
        ? displayString
        : "$displayString (${getCountFromAlertFilter(type, targetList, googleId)})";
  }

  static int getCountFromAlertFilter(
      AlertFilterType type, List<Target> targetList, String googleId) {
    int count = 0;
    switch (type) {
      case AlertFilterType.All:
        count = targetList.length;
        break;
      case AlertFilterType.Unassigned:
        count = TargetUtils.getCountOfUnassigned(targetList);
        break;
      case AlertFilterType.Mine:
        count = TargetUtils.getCountOfMine(targetList, googleId);
        break;
    }
    return count;
  }

  static AlertFilterType getFilterTypeAsString(String typeAsString) {
    for (AlertFilterType element in AlertFilterType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }

  static AlertSortType getSortTypeAsString(String typeAsString) {
    for (AlertSortType element in AlertSortType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }
}

enum AlertFilterType { All, Unassigned, Mine }
