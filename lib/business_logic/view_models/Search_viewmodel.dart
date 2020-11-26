import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
/* ----------------------------- All Declaration ---------------------------- */

  TextEditingController _searchInputText = TextEditingController();
  String _searchedName = '';

/* ------------------------------- All getters ------------------------------ */

  get searchInputText => _searchInputText;
  get searchedName => _searchedName;

/* ------------------------------- All setters ------------------------------ */
  set searchInputText(value) {
    _searchInputText = value;
  }

  set searchedName(value) {
    _searchedName = value;
    notifyListeners();
  }
}
