import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String _title = 'Home View';
  String get title => _title;
  int _counter = 0;
  int get counter => _counter;
  void updateCounter() {
    _counter++;
    print("updating Counter");
    notifyListeners();
  }
}
