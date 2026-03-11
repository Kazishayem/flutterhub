import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _themeModeKey = 'theme_mode';

  static Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await prefs.remove(_tokenKey);
      return;
    }
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> setUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    if (userData == null || userData.isEmpty) {
      return null;
    }
    return jsonDecode(userData) as Map<String, dynamic>;
  }

  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  static Future<bool> hasSession() async {
    final token = await getToken();
    final user = await getUserData();
    return token != null && token.isNotEmpty && user != null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> setRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', "$role");
  }

  static Future<void> removeRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
  }

  Future<String?> getEmailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> setEmailId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', id ?? 'No email_id');
  }

  Future<void> removeEmailId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
  }
}
