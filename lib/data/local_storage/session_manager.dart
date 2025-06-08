import 'package:hive/hive.dart';

class SessionManager {
  static late Box _sessionBox;
  static const String _sessionKey = 'currentUserId';

  static Future<void> init() async {
    _sessionBox = await Hive.openBox('app_session');
  }

  static Future<void> setUserId(String userId) async {
    await _sessionBox.put(_sessionKey, userId);
  }

  static String? getUserId() {
    return _sessionBox.get(_sessionKey);
  }

  static Future<void> clearSession() async {
    await _sessionBox.delete(_sessionKey);
  }

  static bool isAuthenticated() {
    return getUserId() != null;
  }
}