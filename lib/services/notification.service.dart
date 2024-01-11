import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Notificationservice {
  Future getNotifications() async {
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
      Uri.parse('$api/notice/getNotice'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token',
        "origin": "http://182.93.83.242:5002"
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
