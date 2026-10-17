import 'package:shared_preferences/shared_preferences.dart';

class UserPreference
{
  static const String _roleKey = 'user_role';

  // 1. Save the role when they log in
  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  // 2. Read the role instantly on startup
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // 3. Wipe the data when they log out so they go back to Intro
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}