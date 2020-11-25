import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:projectnew/utils/models/userModel.dart';

enum LoadingStatus { Loading, Loaded }

class SplashScreenModel extends ChangeNotifier {
/* ----------------------------- All Declaration ---------------------------- */
  var currentUserId = FirebaseAuth.instance.currentUser.uid;
  UseR _userProfileData;
  UseR _otherUserData;
  bool isloading;
  CollectionReference userref = FirebaseFirestore.instance.collection('users');
  get otherUserData => _otherUserData;
  get userProfileData => _userProfileData;
  set userProfileData(value) {
    _userProfileData = value;
    eventLoadingStatus = LoadingStatus.Loaded;
    notifyListeners();
  }

  set otherUserData(value) {
    _otherUserData = value;
    eventLoadingStatus = LoadingStatus.Loaded;
    notifyListeners();
  }

  get isLoading => isloading;
  set isLoading(value) {
    isloading = value;
    notifyListeners();
  }

  Future getProfileData(var _userid, bool isMe) async {
    print('gettting data');
    await userref.doc(_userid).get().then((DocumentSnapshot documentSnapshot) {
      if (isMe) {
        userProfileData = UseR.fromDocument(documentSnapshot);
      } else {
        otherUserData = UseR.fromDocument(documentSnapshot);
      }
    });
  }

  LoadingStatus _eventLoadingStatus = LoadingStatus.Loading;
  get eventLoadingStatus => _eventLoadingStatus;
  set eventLoadingStatus(value) {
    _eventLoadingStatus = value;
    notifyListeners();
  }

  Future setLoadingStatus(value) async {
    eventLoadingStatus = value;
  }
}
