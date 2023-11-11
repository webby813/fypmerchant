import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


Future<void> SetSharedPref(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setString('password', password);
}