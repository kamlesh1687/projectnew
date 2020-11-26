import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:projectnew/business_logic/models/userModel.dart';

enum LoadingStatus { Loading, Loaded }

class SplashScreenModel extends ChangeNotifier {
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
    var user = FirebaseAuth.instance.currentUser;

    if (_profileUserModelList == null) {
      _profileUserModelList = [];
    }
    print("getting data");
    userid = userid == null ? user.uid : userid;

    userref.doc(userid).get().then((DocumentSnapshot snapshot) {
      _profileUserModelList.add(UseR.fromDocument(snapshot));
      print(_profileUserModelList.last.displayName);
      if (userid == user.uid) {
        _userModel = _profileUserModelList.last;

        print("getProfileData if userid==user.id");
        print(loadingStatus);
      }
    }).then((value) {
      loadingStatus = LoadingStatus.Loaded;
      notifyListeners();
    });

    return _userModel;
  }

  void removeLastUser() {
    print("lastUserRemoved");
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
    print(loadingStatus);
    getProfileData(userid: _userId);
  }
}
