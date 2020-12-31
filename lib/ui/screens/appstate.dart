import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isBusy = false;
  bool get isbusy => _isBusy;

  set loading(bool value) {
    _isBusy = value;
    print('changed loading value');
    notifyListeners();
  }
}
