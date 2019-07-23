import 'package:wasabee/pages/linkspage/linksortdialog.dart';

class LinkSortManager {
  static List<LinkSortType> getFilters() {
    var sortTypeList = List<LinkSortType>();
    sortTypeList.add(LinkSortType.AlphaFromPortal);
    sortTypeList.add(LinkSortType.AlphaToPortal);
    sortTypeList.add(LinkSortType.LinkLength);
    sortTypeList.add(LinkSortType.LinkOrder);
    return sortTypeList;
  }

  static String getDisplayStringFromEnum(LinkSortType type) {
    String displayString = "";
    switch (type) {
      case LinkSortType.AlphaFromPortal:
        displayString = "From Portal Name";
        break;
      case LinkSortType.AlphaToPortal:
        displayString = "To Portal Name";
        break;
      case LinkSortType.LinkLength:
        displayString = "Link Length";
        break;
      case LinkSortType.LinkOrder:
        displayString = "Link Order";
        break;
    }
    return displayString;
  }
}
