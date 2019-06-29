import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {

  static const KEY_SELECTED_OPERATION = "KEY_SELECTED_OPERATION";

  static Future<String> getSelectedOpId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_SELECTED_OPERATION) ?? '';
  }

  static storeSelectedOpId(String operationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_SELECTED_OPERATION, operationId);
  }
}
