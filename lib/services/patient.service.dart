import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PatientService {
  Future getAllPAtients(name, currentPage) async {
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

    var data = {
      "filter": [
        {"field": "name", "value": name ?? ""},
        {"field": "registrationNo", "value": ""},
        {"field": "contactNumber", "value": ""},
        {"field": "gender", "value": ""},
        {"field": "age", "value": ""}
      ],
      "pagination": {"pageIndex": currentPage, "pageSize": 25},
      "sortDTO": [
        {"field": "name", "orderType": "asc"}
      ]
    };

    final response = await http.post(
      Uri.parse('$api/master/patients/view'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // ignore: avoid_print
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
