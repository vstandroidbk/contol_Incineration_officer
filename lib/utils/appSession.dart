import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  static const String _userIdKey = "user_id";
  static const String _tokenKey = "auth_token";
  static const String _playerIdKey = "onesignal_player_id";

  /// --- TOKEN METHODS ---
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// --- USER ID METHODS ---
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// --- ONESIGNAL PLAYER ID ---
  static Future<void> savePlayerId(String playerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playerIdKey, playerId);
  }

  static Future<String?> getPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_playerIdKey);
  }

  /// --- LOGOUT / CLEAR ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ── 1. Opt out BEFORE clearing local data ──────────────────────
    try {
      OneSignal.User.pushSubscription.optOut();
      await OneSignal.logout();
    } catch (e) {
      print("OneSignal logout error: $e");
    }

    // ── 2. Clear local session data ─────────────────────────────────
    await prefs.remove(_userIdKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_playerIdKey);
  }

  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}