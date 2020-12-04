import '../appstate.dart';

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
