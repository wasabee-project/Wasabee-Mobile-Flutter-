import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasabee/pages/alertspage/alertfiltermanager.dart';
import 'package:wasabee/pages/alertspage/alertsortdialog.dart';

class LocalStorageUtils {
  static const KEY_SELECTED_OPERATION = "KEY_SELECTED_OPERATION";
  static const KEY_SHARING_LOCATION = "KEY_SHARING_LOCATION";
  static const KEY_GOOGLE_ID = "KEY_GOOGLE_ID";
  static const KEY_ALERT_FILTER = "KEY_ALERT_FILTER";
  static const KEY_ALERT_SORT = "KEY_ALERT_SORT";

  static Future<String> getSelectedOpId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_SELECTED_OPERATION) ?? '';
  }

  static Future<dynamic> storeSelectedOpId(String operationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_SELECTED_OPERATION, operationId);
  }

  static Future<bool> getIsLocationSharing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_SHARING_LOCATION) ?? false;
  }

  static Future<dynamic> storeIsLocationSharing(bool isLocationSharing) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_SHARING_LOCATION, isLocationSharing);
  }

  static Future<String> getGoogleId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_GOOGLE_ID) ?? null;
  }

  static Future<dynamic> storeGoogleId(String googleId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_GOOGLE_ID, googleId);
  }

  static Future<AlertFilterType> getAlertFilter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AlertFilterManager.getFilterTypeAsString(
            prefs.getString(KEY_ALERT_FILTER)) ??
        AlertFilterType.All;
  }

  static Future<dynamic> setAlertfilter(AlertFilterType filter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ALERT_FILTER, filter.toString());
  }

  static Future<AlertSortType> getAlertSort() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AlertFilterManager.getSortTypeAsString(
            prefs.getString(KEY_ALERT_SORT)) ??
        AlertSortType.Distance;
  }

  static Future<dynamic> setAlertSort(AlertSortType sort) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ALERT_SORT, sort.toString());
  }
}
