import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linkfiltermanager.dart';

class LinkUtils {
  static int getCountOfUnassigned(List<Link> linkList) {
    return getUnassignedList(linkList).length;
  }

  static List<Link> getUnassignedList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList
            .where((i) => i.assignedTo?.isEmpty == true || i.assignedTo == null)
            .toList();
  }

  static int getCountOfMine(List<Link> linkList, String googleId) {
    return getMyList(linkList, googleId).length;
  }

  static List<Link> getMyList(List<Link> linkList, String googleId) {
    return linkList == null
        ? List<Link>()
        : linkList
            .where((i) =>
                i.assignedTo?.isNotEmpty == true && i.assignedTo == googleId)
            .toList();
  }

  static int getCountOfComplete(List<Link> linkList) {
    return getCompleteList(linkList).length;
  }

  static List<Link> getCompleteList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList.where((i) => i.completed == true).toList();
  }

    static int getCountOfIncomplete(List<Link> linkList) {
    return getIncompleteList(linkList).length;
  }

  static List<Link> getIncompleteList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList.where((i) => i.completed != true).toList();
  }

  static List<Link> getFilteredLinks(
      List<Link> linkList, LinkFilterType type, String googleId) {
    var returningList = List<Link>();
    switch (type) {
      case LinkFilterType.All:
        returningList = linkList;
        break;
      case LinkFilterType.Unassigned:
        returningList = getUnassignedList(linkList);
        break;
      case LinkFilterType.Mine:
        returningList = getMyList(linkList, googleId);
        break;
      case LinkFilterType.Complete:
        returningList = getCompleteList(linkList);
        break;
      case LinkFilterType.Incomplete:
        returningList = getIncompleteList(linkList);
        break;
    }
    return returningList;
  }
}
