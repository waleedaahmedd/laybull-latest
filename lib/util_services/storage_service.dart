import 'package:laybull_v3/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  getData(String key) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? data = storage.getString(key);
    if (data != null) {
      // final data2 = json.decode(data);

      UserModel dummy = UserModel.fromJson(data);
      return dummy;
    }
    return data;
  }

  setData(String key, dynamic data) async {
    var storage = await SharedPreferences.getInstance();
    // var encodedData = json.encode(data);
    await storage.setString(key, jsonEncode(data));
  }

  haveData(String key) async {
    var storage = await SharedPreferences.getInstance();
    var v = storage.containsKey(key);
    return v;
  }

  saveAccessToken(String key, String token) async {
    var storage = await SharedPreferences.getInstance();
    await storage.setString(key, token.toString());
  }

  getAccessToken(String key) async {
    var storage = await SharedPreferences.getInstance();
    var data = storage.get(key);
    if (data != null) {
      return data;
    }
    return data;
  }

  setBoolData(String key, bool data) async {
    var storage = await SharedPreferences.getInstance();
    await storage.setBool(key, data);
  }

  haveBoolData(String key) async {
    var storage = await SharedPreferences.getInstance();
    var v = storage.containsKey(key);
    return v;
  }

  getBoolData(String key) async {
    var storage = await SharedPreferences.getInstance();
    var data = storage.get(key);

    return data;
  }

  removeData(String key) async {
    var storage = await SharedPreferences.getInstance();
    var v = storage.remove(key);
    return v;
  }
}
