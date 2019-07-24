import 'package:wasabee/classutils/link.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';

class LinkFilterManager {
  static List<LinkFilterType> getFilters() {
    var filterTypeList = List<LinkFilterType>();
    filterTypeList.add(LinkFilterType.All);
    filterTypeList.add(LinkFilterType.Unassigned);
    filterTypeList.add(LinkFilterType.Mine);
    filterTypeList.add(LinkFilterType.Complete);
    filterTypeList.add(LinkFilterType.Incomplete);
    return filterTypeList;
  }

  static String getDisplayStringFromEnum(
      LinkFilterType type, List<Link> linkFilter, String googleId) {
    String displayString = "";
    switch (type) {
      case LinkFilterType.All:
        displayString = "All Links";
        break;
      case LinkFilterType.Unassigned:
        displayString = "Unassigned Links";
        break;
      case LinkFilterType.Mine:
        displayString = "My Links";
        break;
      case LinkFilterType.Complete:
        displayString = "Complete Links";
        break;
      case LinkFilterType.Incomplete:
        displayString = "Incomplete Links";
        break;
    }
    return linkFilter == null
        ? displayString
        : "$displayString (${getCountFromLinkFilter(type, linkFilter, googleId)})";
  }

  static int getCountFromLinkFilter(
      LinkFilterType type, List<Link> linkFilter, String googleId) {
    int count = 0;
    switch (type) {
      case LinkFilterType.All:
        count = linkFilter.length;
        break;
      case LinkFilterType.Unassigned:
        count = LinkUtils.getCountOfUnassigned(linkFilter);
        break;
      case LinkFilterType.Mine:
        count = LinkUtils.getCountOfMine(linkFilter, googleId);
        break;
      case LinkFilterType.Complete:
        count = LinkUtils.getCountOfComplete(linkFilter);
        break;
      case LinkFilterType.Incomplete:
        count = LinkUtils.getCountOfIncomplete(linkFilter);
        break;
    }
    return count;
  }

  static LinkFilterType getFilterTypeAsString(String typeAsString) {
    for (LinkFilterType element in LinkFilterType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }

  static LinkSortType getSortTypeAsString(String typeAsString) {
    for (LinkSortType element in LinkSortType.values) {
      if (element.toString() == typeAsString) {
        return element;
      }
    }
    return null;
  }
}

enum LinkFilterType { All, Unassigned, Mine, Complete, Incomplete }
