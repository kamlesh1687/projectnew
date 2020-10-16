import 'package:flutter/Material.dart';
import 'package:projectnew/utils/models/userModel.dart';

class SplashScreenModel extends ChangeNotifier {
/* ----------------------------- All Declaration ---------------------------- */
  String _userId;
  UseR _userProfileData;
  get userId => _userId;
  set userId(value) {
    _userId = value;
  }

  get userProfileData => _userProfileData;
  set userProfileData(value) {
    _userProfileData = value;
  }
}
