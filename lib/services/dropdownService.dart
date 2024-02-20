import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DropDownService {
  getPatientDropDownList(query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('userList') ?? [];
    String? api;
    String? token;
    for (String userInfoString in userList) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (userInfo['active'] == true) {
        token = userInfo['token'];
        api = userInfo['api'];
        break;
      }
    }

    final response = await http.get(
      Uri.parse('$api/dropdown/patients/$query'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      // ignore: avoid_print
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
