
import 'package:flutter/material.dart';

class AppState with ChangeNotifier{

  bool _isLogin = false;

  bool _darkMode = false;

  double _fontSize;




  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }


  void init(bool isLogin, bool darkMode, fontSize) {
    this._isLogin = isLogin;
    this.darkMode = darkMode;
    this.fontSize = fontSize;
    notifyListeners();
  }




}