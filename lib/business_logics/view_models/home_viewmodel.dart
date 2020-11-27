import 'package:projectnew/business_logics/appstate.dart';

class HomeViewModel extends AppState {
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
