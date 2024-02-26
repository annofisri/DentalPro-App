// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:dental/pages/home.dart';
import 'package:dental/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  final TextEditingController url = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  String companyName = '';
  String userImage = '';

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('userList') ?? [];
    if (userList.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  login() async {
    RegExp usernameRegEx = RegExp(r'^[a-zA-Z0-9_]+$');
    RegExp passwordRegEx =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    bool validUsername = usernameRegEx.hasMatch(username.text);
    bool validPassword = passwordRegEx.hasMatch(password.text);

    if (!validUsername) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter a valid Username!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter a valid Password!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final data = {"username": username.text, "password": password.text};

    var response = await authService.login(data, url.text);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var user_id = data['user_information']['id'];
      var token = data['authorization']['token'];

      getUserImage(token, user_id, url.text);

      final userInfo = {
        "api": url.text,
        "companyName": companyName,
        "active": true,
        "token": data['authorization']['token'],
        "userId": data['user_information']['id'],
        "userName": username.text,
        "name": data['user_information']['name'],
        "title": data['user_information']['title'],
        "image": userImage,
        "permissions": data['user_information']['operations']
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? userList = prefs.getStringList('userList') ?? [];
      userList.add(jsonEncode(userInfo));
      prefs.setStringList('userList', userList);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error['message'].toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  getUserImage(token, id, uri) async {
    var res = await authService.getUserImage(token, id, uri);
    if (res.statusCode == 200) {
      setState(() {
        userImage = base64Encode(res.bodyBytes);
      });
    } else {
      print('Error');
    }
  }

  checkURL() async {
    if (url.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter a valid Workspace URL!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      var response = await authService.checkURL(url.text);
      setState(() {
        companyName = response[0]['company_name'];
      });
      login();
    } catch (error) {
      String errorMessage = error.toString();
      if (error is Exception) {
        errorMessage = error.toString().replaceFirst('Exception:', '');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(249, 249, 250, 1),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/login_background.png"),
              fit: BoxFit.fitWidth,
              alignment: AlignmentDirectional.bottomEnd),
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: SvgPicture.asset(
                'assets/login_logo.svg',
                width: 205,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 60, 0, 30),
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Text(
                      'Enter Workspace URL',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: url,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Text(
                        'Forgot Password',
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(color: Color.fromRGBO(54, 135, 147, 1)),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => checkURL(),
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(54, 135, 147, 1),
                                padding:
                                    EdgeInsets.fromLTRB(134, 16, 134, 15))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
