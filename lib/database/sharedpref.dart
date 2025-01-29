import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  addString(String key, String value) async {
    await asyncPrefs.setString(key, value);
    // print(result);
  }

  Future<String> getString(String key) async {
    // print("$key ${asyncPrefs?.getString(key)}");
    return await asyncPrefs.getString(key) ?? '';
  }

  addInt(String key, int value) async {
    await asyncPrefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return await asyncPrefs.getInt(key);
  }
}
