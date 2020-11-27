import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectnew/business_logics/models/userModel.dart';

import '../appstate.dart';

enum LoadingStatus { Loading, Loaded }

class SplashScreenModel extends AppState {
  LoadingStatus _loadingStatus = LoadingStatus.Loading;
/* ----------------------------- All Declaration ---------------------------- */
  var currentUserId = FirebaseAuth.instance.currentUser.uid;

  // UseR _otherUserData;

  CollectionReference userref = FirebaseFirestore.instance.collection('users');

/* -------------------------------------------------------------------------- */
/*                              Getter and Setter                             */
/* -------------------------------------------------------------------------- */

  List<UseR> _profileUserModelList;
  UseR _userModel;

  UseR get userModel => _userModel;

  UseR get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    } else {
      return null;
    }
  }

  Future<UseR> getProfileData({String userid}) async {
    print('gretting data');
    var user = FirebaseAuth.instance.currentUser;

    if (_profileUserModelList == null) {
      _profileUserModelList = [];
    }

    userid = userid == null ? user.uid : userid;

    userref.doc(userid).get().then((DocumentSnapshot snapshot) {
      _profileUserModelList.add(UseR.fromDocument(snapshot));

      if (userid == user.uid) {
        _userModel = _profileUserModelList.last;
      }
    }).then((value) {
      loadingStatus = LoadingStatus.Loaded;
      notifyListeners();
    });

    return _userModel;
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
    notifyListeners();
  }

  // get otherUserData => _otherUserData;

  get loadingStatus => _loadingStatus;
  set loadingStatus(value) {
    _loadingStatus = value;
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */
/*                                Get User Data                               */
/* -------------------------------------------------------------------------- */

  updateUserData(var _userId) {
    loadingStatus = LoadingStatus.Loading;

    getProfileData(userid: _userId);
  }
}
