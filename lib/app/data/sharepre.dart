// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveUser(User objUser, String token) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? check = prefs.getString('user');
    if (check != null) {
      prefs.setString('user', '');
      prefs.setString('authToken', '');
    }
    String strUser = jsonEncode(objUser);
    prefs.setString('user', strUser);
    prefs.setString('authToken', token);
    print("Luu thanh cong: $strUser");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> logOut(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', '');
    print("Logout thành công");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

//
Future<User> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? check = pref.getString('user');
  User user = User.fromJson(jsonDecode(check!));
  return user;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String check = pref.getString('authToken')!;
  return check;
}
