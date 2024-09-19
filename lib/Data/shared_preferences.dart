import 'package:shared_preferences/shared_preferences.dart';


// Save user preference
Future<void> savePreference(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// Retrieve user preference
Future<String?> getPreference(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);  // returns null if the key doesn't exist
}

// Remove user preference
Future<void> removePreference(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}



