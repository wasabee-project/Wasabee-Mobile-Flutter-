import 'package:wasabee/pages/alertspage/alertsortdialog.dart';

class AlertSortManager {
  static List<AlertSortType> getFilters() {
    var sortTypeList = List<AlertSortType>();
    sortTypeList.add(AlertSortType.AlphaName);
    sortTypeList.add(AlertSortType.CurrentState);
    sortTypeList.add(AlertSortType.Distance);
    sortTypeList.add(AlertSortType.TargetType);
    return sortTypeList;
  }

  static String getDisplayStringFromEnum(AlertSortType type) {
    String displayString = "";
    switch (type) {
      case AlertSortType.AlphaName:
        displayString = "Portal Name";
        break;
      case AlertSortType.CurrentState:
        displayString = "Current State";
        break;
      case AlertSortType.Distance:
        displayString = "Distance";
        break;
      case AlertSortType.TargetType:
        displayString = "Target Type";
        break;
    }
    return displayString;
  }
}
