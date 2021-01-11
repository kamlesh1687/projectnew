import 'appstate.dart';
import 'package:projectnew/features/data/datasources/remote/userServices.dart';

UserService firebaseServices = UserService();

class SearchViewModel extends AppState {
/* ----------------------------- All Declaration ---------------------------- */

  String _searchedName = '';

/* ------------------------------- All getters ------------------------------ */

  get searchedName => _searchedName;

/* ------------------------------- All setters ------------------------------ */

  set searchedName(value) {
    _searchedName = value;
    notifyListeners();
  }
}
