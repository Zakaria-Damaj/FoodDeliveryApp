import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool isLoggedIn = false;
  String userId = '0';
  String username = '';
  String password = '';

  // Method to initialize user data from SharedPreferences
  Future<void> initializeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    userId = prefs.getString('uid') ?? '0';
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
    notifyListeners();
  }

  // Method to set login status and user data
  void login(String id, String uname, String pass) {
    isLoggedIn = true;
    userId = id;
    username = uname;
    password = pass;

    // Save login status and user data to SharedPreferences
    saveLoginStatus();
    saveUserData();
    notifyListeners();
  }

  // Method to clear login status and user data
  void logout() {
    isLoggedIn = false;
    userId = '0';
    username = '';
    password = '';

    // Clear login status and user data from SharedPreferences
    clearLoginStatus();
    clearUserData();
    notifyListeners();
  }

  // Method to save login status
  void saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  // Method to clear login status
  void clearLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  // Method to save user data
  void saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userId);
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  // Method to clear user data
  void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('username');
    prefs.remove('password');
  }
}
