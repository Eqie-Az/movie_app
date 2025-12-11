import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = "";
  String _userPhone = "";
  String _userPassword = "";

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userPassword => _userPassword;

  void login(String name, String phone, String password) {
    _isLoggedIn = true;
    _userName = name;
    _userPhone = phone;
    _userPassword = password;
    notifyListeners();
  }

  // [BARU] Fungsi untuk update data real-time
  void updateData(String name, String phone, String password) {
    _userName = name;
    _userPhone = phone;
    _userPassword = password;
    notifyListeners(); // Refresh UI otomatis
  }

  void logout() {
    _isLoggedIn = false;
    _userName = "";
    _userPhone = "";
    _userPassword = "";
    notifyListeners();
  }
}
