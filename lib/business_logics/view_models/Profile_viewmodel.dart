import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';

import 'package:projectnew/services/firebaseServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/screens/appstate.dart';

FirebaseServices firebaseServices = FirebaseServices();
FeedViewModel feedViewModel = FeedViewModel();

class ProfileViewModel extends AppState {
  EventLoadingStatus profileLoadingStatus = EventLoadingStatus.Loading;

  /* ------------------ Declaration of variables and objects ------------------ */
  setProfileLoadingStatus(value) {
    profileLoadingStatus = value;
    notifyListeners();
  }

  String myUid;
  setMyUserId(value) {
    myUid = value;
    notifyListeners();
  }

  List<UseR> _profileUserModelList;
  UseR _userModel;
  List<PosT> _postModel;

  List<List<PosT>> _postGridModelList;
  File _fileImage;

  bool isLoadingPost = true;
  bool isLoggedIn;
  setIsLoggedIn(value) {
    isLoggedIn = value;
    notifyListeners();
  }

/* ------------------------------- All Getters ------------------------------ */
  List<PosT> get postGridModel {
    if (_postGridModelList != null && _postGridModelList.length > 0) {
      return _postGridModelList.last;
    } else {
      return null;
    }
  }

  List<PosT> get postModel => _postModel;
  UseR get userModel => _userModel;

  UseR get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    } else {
      return null;
    }
  }

  File get fileImage => _fileImage;

/* ------------------------------- All Setters ------------------------------ */
  set fileImage(value) {
    _fileImage = value;
    notifyListeners();
  }

/* --------------------- CreateUserwithEmailAndPassword --------------------- */
  Future signUpFunc({String email, String password, String userName}) async {
    loading = true;
    _profileUserModelList = [];
    _postGridModelList = [];
    _postModel = [];

    await firebaseServices.signUp(email, password).then((value) {
      loading = false;
      String _userId = value.user.uid;
      UseR _newUser =
          defaultUser(email: email, userId: _userId, userName: userName);

      firebaseServices.createUser(_newUser);
      _profileUserModelList.add(_newUser);
      saveUserData(_newUser);
      print(_profileUserModelList.length);
      setProfileLoadingStatus(EventLoadingStatus.Loaded);
      _userModel = _profileUserModelList.last;
      _postGridModelList.add(_postModel);

      notifyListeners();
      return value;
    });
  }

/* ----------------------- SignInWithEmailAndPassword ----------------------- */

  void loginmethod(_email, _pass) {
    setIsLoggedIn(true);
    loading = true;

    firebaseServices.signIn(_email, _pass).then((value) {
      print(value);
      setMyUserId(value.user.uid);

      loading = false;
    });
  }

/* ----------------------------- Following ----------------------------- */
  isFollower() {
    if (profileUserModel.followersList != null &&
        profileUserModel.followersList.isNotEmpty) {
      return (profileUserModel.followersList.any((x) => x == userModel.userId));
    } else {
      print('not following');
      return false;
    }
  }

  followUser({bool removeFollower = false}) async {
    if (removeFollower) {
      /// Remove user from data model
      profileUserModel.followersList.remove(userModel.userId);
      userModel.followingList.remove(profileUserModel.userId);

      /// Remove user form firebase
      firebaseServices.unFollowUser(userModel.userId, profileUserModel.userId);

      /// Remove other user's post from my timeline
      firebaseServices.removePostFromTimeLine(
          myUserId: userModel.userId, otherUserID: profileUserModel.userId);
    } else {
      profileUserModel.followersList = profileUserModel.followersList ?? [];

      /// Add user to dataModel
      profileUserModel.followersList.add(userModel.userId);
      userModel.followingList = userModel.followingList ?? [];
      userModel.followingList.add(profileUserModel.userId);

      /// Add user to firebase
      firebaseServices.followUser(userModel.userId, profileUserModel.userId);
    }

    /// Follow count
    profileUserModel.followers = profileUserModel.followersList.length;
    userModel.following = userModel.followingList.length;
    notifyListeners();
  }

/* ------------------------------- isMe or not ------------------------------ */

  Future getUserDataOnline(String _userId) async {
    print('getting online ');
    assert(_userId != null);

    /// Get user data from friebase
    UseR _userData = await firebaseServices.getUserData(_userId);
    if (_userData != null) {
      dataForUserModel(_userData);

      if (_userData.userId == myUid) {
        saveUserData(_userData);
      }
    }
  }

  Future dataForUserModel(UseR _userData) async {
    String _userId = _userData.userId;
    _profileUserModelList = _profileUserModelList ?? [];

    /// Add user data to profilemodel list

    _profileUserModelList.add(_userData);

    final postList = await firebaseServices.getPostData(_userId);
    final postcount = postList.length;
    _profileUserModelList.last.postcount = postcount;
    postGridView(_userId, postList: postList);

    /// Get follower list
    final follower = await firebaseServices.getFollowersList(_userId);
    _profileUserModelList.last.followersList = follower;
    _profileUserModelList.last.followers = follower.length;

    /// Get following list
    final followingUsers = await firebaseServices.getFollowingList(_userId);
    _profileUserModelList.last.followingList = followingUsers;
    _profileUserModelList.last.following = followingUsers.length;

    /// Save my profiledata in other usermodel
    if (_userId == myUid) {
      _userModel = _profileUserModelList.last;
    }
    print('done');

    setProfileLoadingStatus(EventLoadingStatus.Loaded);
    notifyListeners();
  }

  saveUserData(UseR _user) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _pref.setString('userData', jsonEncode(_user));
  }

  deleteUserDataFromSf() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print('userData deleted');
    _pref.remove('userData');
  }

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
      setMyUserId(_user.userId);

      dataForUserModel(_user);

      print('userData is not null');
      return _user;
    }
    return null;
  }

  void removeLastUser() {
    /// Remove othe user data on pressing back button
    if (_profileUserModelList.length > 1) {
      _profileUserModelList.removeLast();
    }
    if (_postGridModelList.length > 1) {
      _postGridModelList.removeLast();
    }
  }

  Future<bool> updateProfile(
      UseR _userData, String _bio, String _userName) async {
    loading = true;
    Reference _storeRef = FirebaseStorage.instance.ref().child(
        'users/${_userData.userId}/userProfile/images/${_userData.userId}');

    try {
      UseR _userUpdate = UseR(
          bio: userModel.bio,
          displayName: userModel.displayName,
          email: userModel.email,
          profilePic: userModel.profilePic,
          userId: userModel.userId);

      if (_userName.isNotEmpty) {
        _userUpdate.displayName = _userName;
        _userModel.displayName = _userName;
      }
      if (_bio.isNotEmpty) {
        _userUpdate.bio = _bio;
        _userModel.bio = _bio;
      }
      if (fileImage != null) {
        String _profileUrl = await firebaseServices.uploadImg(
            _userData.userId, fileImage, _storeRef);
        _userUpdate.profilePic = _profileUrl;
        _userModel.profilePic = _profileUrl;
        fileImage = null;
      }

      if (_profileUserModelList != null) {
        _profileUserModelList.last = _userModel;
      }
      firebaseServices.createUser(_userUpdate);
      loading = false;
      saveUserData(_userUpdate);
    } on PlatformException catch (e) {
      print(e);
    }
    return true;
  }

  void logoutCallBack() {
    firebaseServices.signOut();
    _profileUserModelList = null;
    _userModel = null;
    _postGridModelList = null;
    deleteUserDataFromSf();
  }

/* ------------------------------ Image picker ------------------------------ */
  pickImageFromGallery() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (_imagefile != null) {
      cropImage(File(_imagefile.path));
    } else {
      fileImage = null;
    }
  }

  takeImageFromCamera() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.camera);
    if (_imagefile != null) {
      cropImage(File(_imagefile.path));
    } else {
      fileImage = null;
    }
  }

/* ------------------------------ ImageCropper ------------------------------ */
  cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: image.path,
        compressQuality: 25);
    fileImage = croppedImage;
  }

/* -------------------- uploading Image to Cloud_storage -------------------- */

  deleteFile() async {
    fileImage = null;
  }

  setLoadingPost(value) {
    isLoadingPost = value;
    notifyListeners();
  }

  postGridView(_userId, {List<QueryDocumentSnapshot> postList}) async {
    if (isLoadingPost == false) {
      setLoadingPost(true);
    }
    _postGridModelList = _postGridModelList ?? [];
    List<PosT> _postList = [];
    postList.forEach((element) {
      PosT _post = PosT.fromDocument(element);
      if (_post != null) {
        _postList.add(_post);
      }
    });
    if (_postList != null) {
      _postGridModelList.add(_postList);
      if (_userId == myUid) {
        _postModel = _postGridModelList.last;
      }
    }
    isLoadingPost = false;
    notifyListeners();
  }

/* ------------------------------ End of class ------------------------------ */
}
