import 'package:shared_preferences/shared_preferences.dart';

class Sharedpeference {
  static Future<void> addUserId(String userId) async {
    print(userId);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("_userid", userId);
  }

  static Future<void> clearUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("_userid");
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("_userid");
    return userId;
  }
}
