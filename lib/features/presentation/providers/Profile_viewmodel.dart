import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/features/data/datasources/remote/authService.dart';

import 'package:projectnew/features/presentation/providers/Feed_viewmodel.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/data/models/postModel.dart';
import 'package:projectnew/features/data/models/userProfile.dart';
import 'package:projectnew/features/data/repositories/post/postDataImpl.dart';
import 'package:projectnew/features/data/datasources/remote/commonServices.dart';
import 'package:projectnew/features/data/datasources/remote/postService.dart';
import 'package:projectnew/features/domain/repositories/Post/PostData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appstate.dart';

FeedViewModel feedViewModel = FeedViewModel();


PostData postData = PostDataImpl();

class ProfileViewModel extends AppState {
  /* ------------------ Declaration of variables and objects ------------------ */

  List<ProfileUser> _profileUserList;

  ProfileUser _myProfileData;
  File _fileImage;
  bool _isLoggedIn;
  bool _isLoadingPost = true;
  String _userID;
  bool _isMe = true;
  EventLoadingStatus profileLoadingStatus = EventLoadingStatus.Loading;

/* ------------------------------- All Getters ------------------------------ */
  bool get isMe => _isMe;
  bool get isLoadingPost => _isLoadingPost;
  bool get isLoggedIn => _isLoggedIn;
  String get userID => _userID;

  ProfileUser get myProfileData => _myProfileData;
  File get fileImage => _fileImage;
  ProfileUser get profileUser {
    if (_profileUserList != null && _profileUserList.length > 0) {
      return _profileUserList.last;
    } else {
      return null;
    }
  }

/* ------------------------------- All Setters ------------------------------ */
  setProfileLoadingStatus(value) {
    profileLoadingStatus = value;
    notifyListeners();
  }

  set userID(value) {
    _userID = value;
    notifyListeners();
  }

/* --------------------- CreateUserwithEmailAndPassword --------------------- */
  Future signUpFunc({String email, String password, String userName}) async {
    loading = true;
    // List<PosT> _emptyPostList = [];
    // ProfileUser _new;
    _profileUserList = [];

    // await AuthService().signUp(email, password).then((value) {
    //   loading = false;
    //   _userID = value.user.uid;
    //   print(userID);
    //   print(value.user.uid);
    //   notifyListeners();
    //   UseR _newUser =
    //       defaultUser(email: email, userId: userID, userName: userName);

    //   firebaseServices.createUser(_newUser);

    //   _new = ProfileUser(postList: _emptyPostList, userData: _newUser);
    //   _profileUserList.add(_new);
    //   saveUserData(_newUser);
    //   setProfileLoadingStatus(EventLoadingStatus.Loaded);
    //   _myProfileData = _profileUserList.last;

    //   notifyListeners();
    //   return value.user;
    // });
  }

/* ----------------------- SignInWithEmailAndPassword ----------------------- */

  void loginmethod(_email, _pass) {
    // _isLoggedIn = true;
    // loading = true;
    // notifyListeners();

    // AuthService().signIn(_email, _pass).then((value) {
    //   _userID = value.user.uid;
    //   loading = false;
    //   notifyListeners();
    // });
  }

/* --------------------------------- Logout --------------------------------- */
  void logoutCallBack() {
    AuthService().signOut();

    _myProfileData = null;
    _profileUserList = null;
    _userID = null;
    deleteUserDataFromSf();
  }

/* -------------------------------------------------------------------------- */
/*                                 UserProfile                                */
/* -------------------------------------------------------------------------- */

  bool isMyProfile(String _userId) {
    bool isme = _userId == userID;
    _isMe = isme;
    print(_isMe);
    notifyListeners();
    if (!isme) {
      if (_userId != null) {
        // getUserProfileData(_userId);
      } else {
        print('userId is not there');
      }
      return false;
    }

    return true;
  }

/* ----------------------- Get userData form firebase ----------------------- */

  Future getUserDataOnline(String _userId) async {
    // _setProfileUser(Response.loading());
    print('getting online ');
    assert(_userId != null);

// = await firebaseServices.getUser(_userId);
    UseR _userData;
    if (_userData != null) {
      // dataForUserModel(_userData).then((value) {
      //   _isLoggedIn = null;
      //   notifyListeners();
      // });

      if (_userData.userId == userID) {
        saveUserData(_userData);
      }
    }
  }

/* ----------------------------- Following ----------------------------- */

  //new
  bool isFollower() {
    if (profileUser.userData.followersList != null &&
        profileUser.userData.followersList.isNotEmpty) {
      return (profileUser.userData.followersList
          .any((x) => x == myProfileData.userData.userId));
    } else {
      print('not following');
      return false;
    }
  }

/* ----------------------------- Follow Unfollow ---------------------------- */

  followUser({bool removeFollower = false}) async {
    if (removeFollower) {
      /// Remove user from data model

      //new
      profileUser.userData.followersList.remove(myProfileData.userData.userId);
      myProfileData.userData.followingList.remove(profileUser.userData.userId);

      /// Remove user form firebase
      firebaseServices.unFollowUser(
          myProfileData.userData.userId, profileUser.userData.userId);

      /// Remove other user's post from my timeline
      PostService().removePostFromTimeLine(
          myUserId: myProfileData.userData.userId,
          otherUserID: profileUser.userData.userId);
    } else {
      //new
      profileUser.userData.followersList =
          profileUser.userData.followersList ?? [];
      profileUser.userData.followersList.add(myProfileData.userData.userId);
      myProfileData.userData.followingList =
          myProfileData.userData.followingList ?? [];
      myProfileData.userData.followingList.add(profileUser.userData.userId);

      /// Add user to firebase
      firebaseServices.followUser(
          myProfileData.userData.userId, profileUser.userData.userId);
    }

    /// Follow count

    //new
    profileUser.userData.followers = profileUser.userData.followersList.length;
    myProfileData.userData.following =
        myProfileData.userData.followingList.length;
    notifyListeners();
  }

/* ------------------------- Handle Profile UserData ------------------------ */

/* ------------------------------ Get PostData ------------------------------ */

  List<PosT> postGridView(_userId, {List<QueryDocumentSnapshot> postList}) {
    if (isLoadingPost == false) {
      _isLoadingPost = true;
      notifyListeners();
    }

    List<PosT> _postList = [];
    postList.forEach((element) {
      PosT _post = PosT.fromDocumentSnapshot(documentSnapshot: element);
      if (_post != null) {
        _postList.add(_post);
      }
    });
    if (_postList != null) {
      _isLoadingPost = false;
      notifyListeners();
      return _postList;
    }

    return null;
  }

/* -------------------------- Handle other userdata ------------------------- */
  ///Remove othe user data on pressing back button

  Future<bool> onWillPop() async {
    if (_profileUserList.length > 1 && !isMe) {
      _isMe = true;
      //new change
      _profileUserList.removeLast();
    }

    return true;
  }

/* ------------------------- Update userProfile data ------------------------ */

  Future<bool> updateProfile(String _bio, String _userName) async {
    loading = true;
    Reference _storeRef = FirebaseStorage.instance
        .ref()
        .child('users/$userID/userProfile/images/$userID');

    try {
      UseR _userUpdate = UseR(
          bio: _myProfileData.userData.bio,
          displayName: _myProfileData.userData.displayName,
          email: _myProfileData.userData.email,
          profilePic: _myProfileData.userData.profilePic,
          userId: _myProfileData.userData.userId);

      if (_userName.isNotEmpty) {
        _userUpdate.displayName = _userName;
        //new
        _myProfileData.userData.displayName = _userName;
      }
      if (_bio.isNotEmpty) {
        _userUpdate.bio = _bio;
        //new
        _myProfileData.userData.bio = _bio;
      }
      if (fileImage != null) {
        String _profileUrl =
            await CommonServices().uploadImg(userID, fileImage, _storeRef);
        _userUpdate.profilePic = _profileUrl;

        //new
        _myProfileData.userData.profilePic = _profileUrl;
        _fileImage = null;
        notifyListeners();
      }

      if (_profileUserList != null) {
        _profileUserList.last = _myProfileData;
      }
      // firebaseServices.createUser(_userUpdate);
      loading = false;
      saveUserData(_userUpdate);
    } on PlatformException catch (e) {
      print(e);
    }
    return true;
  }

/* -------------------------------------------------------------------------- */
/*                              SharedPreferences                             */
/* -------------------------------------------------------------------------- */

/* --------------------- Save UserData SharedPreferences -------------------- */

  saveUserData(UseR _user) async {
    print('saving');
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _pref.setString('userData', jsonEncode(_user));
  }

/* ------------------ Delete UserData from SharedPrefrences ----------------- */

  deleteUserDataFromSf() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print('userData deleted');
    _pref.remove('userData');
  }

/* ------------------- Load UserData from SharedPrefrences ------------------ */

  Future<UseR> loadUserDataFormSf() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;
    final String userStr = _pref.getString('userData');
    if (userStr != null) {
      userMap = jsonDecode(userStr);
    }
    if (userMap != null) {
      UseR _user;
      _user = UseR.fromJson(userMap);
      _userID = _user.userId;

      notifyListeners();

      return _user;
    }
    return null;
  }

/* -------------------------------------------------------------------------- */
/*                                 ImagePicker                                */
/* -------------------------------------------------------------------------- */

  pickImageFromGallery() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (_imagefile != null) {
      cropImage(File(_imagefile.path));
    } else {
      _fileImage = null;
      notifyListeners();
    }
  }

  takeImageFromCamera() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.camera);
    if (_imagefile != null) {
      cropImage(File(_imagefile.path));
    } else {
      _fileImage = null;
      notifyListeners();
    }
  }

/* ------------------------------ ImageCropper ------------------------------ */
  cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: image.path,
        compressQuality: 25);
    _fileImage = croppedImage;
    notifyListeners();
  }

  deleteFile() async {
    _fileImage = null;
    notifyListeners();
  }

/* ------------------------------ End of class ------------------------------ */
}
