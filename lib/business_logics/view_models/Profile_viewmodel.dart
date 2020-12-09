import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import '../appstate.dart';

enum EventLoadingStatus { Loading, Loaded }

class ProfileViewModel extends AppState {
  /* ------------------ Declaration of variables and objects ------------------ */
  String myUid = FirebaseAuth.instance.currentUser.uid;
  List<UseR> _profileUserModelList;
  UseR _userModel;
  String postCount;
  List<List<PosT>> _postGridList;
  File _fileImage;
  bool isUpdating = false;
  EventLoadingStatus _eventLoadingStatus = EventLoadingStatus.Loading;

/* ------------------------------- All Getters ------------------------------ */
  List<PosT> get postGrids {
    if (_postGridList != null && _postGridList.length > 0) {
      return _postGridList.last;
    } else {
      return null;
    }
  }

  UseR get userModel => _userModel;
  UseR get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    } else {
      return null;
    }
  }

  File get fileImage => _fileImage;
  EventLoadingStatus get eventLoadingStatus => _eventLoadingStatus;
/* ------------------------------- All Setters ------------------------------ */
  set fileImage(value) {
    _fileImage = value;
    notifyListeners();
  }

  set eventLoadingStatus(value) {
    _eventLoadingStatus = value;
    notifyListeners();
  }

  void updating(value) {
    isUpdating = value;
    notifyListeners();
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

    /// Aollow count
    profileUserModel.followers = profileUserModel.followersList.length;
    userModel.following = userModel.followingList.length;
    notifyListeners();
  }

/* ------------------------------- isMe or not ------------------------------ */

  Future getUserProfileData(String _userId) async {
    _userId = _userId ?? myUid;
    _profileUserModelList = _profileUserModelList ?? [];

    /// Get user data from friebase
    UseR _userData = await firebaseServices.getUserData(_userId);

    /// Add user data to profilemodel list
    if (_userData != null) {
      _profileUserModelList.add(_userData);
    }

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

    getUserPost(_userId).then((value) {
      postGridView(_userId).then((value) {});
    });
    eventLoadingStatus = EventLoadingStatus.Loaded;
    notifyListeners();
  }

  Future otheUserProfileData(UseR _userData) async {
    /// Add other user data to profile model list
    _profileUserModelList.add(_userData);

    /// Get follower list
    final follower = await firebaseServices.getFollowersList(_userData.userId);
    _profileUserModelList.last.followersList = follower;
    _profileUserModelList.last.followers = follower.length;

    /// Get following list
    final followingUsers =
        await firebaseServices.getFollowingList(_userData.userId);
    _profileUserModelList.last.followingList = followingUsers;
    _profileUserModelList.last.following = followingUsers.length;

    getUserPost(_userData.userId).then((value) {
      postGridView(_userData.userId).then((value) {
        eventLoadingStatus = EventLoadingStatus.Loaded;
      });
    });

    notifyListeners();
  }

  void removeLastUser() {
    /// Remove othe user data on pressing back button
    _profileUserModelList.removeLast();
    if (_postGridList.length > 1) {
      _postGridList.removeLast();
    }
  }

  Future<bool> updateProfile(
      UseR _userData, String _bio, String _userName) async {
    StorageReference _storeRef = FirebaseStorage.instance.ref().child(
        'users/${_userData.userId}/userProfile/images/${_userData.userId}');

    try {
      UseR _userUpdate = userModel.copyWith(
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
    } on PlatformException catch (e) {
      print(e);
    }
    return true;
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

  getUserPost(String _userId) async {
    List<QueryDocumentSnapshot> _postList =
        await firebaseServices.getPostData(_userId);
    postCount = _postList.length.toString();
    notifyListeners();
  }

  postGridView(_userId) async {
    _postGridList = _postGridList ?? [];

    List<PosT> _postList = [];

    await firebaseServices.getPostData(_userId).then((value) {
      print("getting Post");
      value.forEach((element) {
        PosT _post = PosT.fromDocument(element);
        if (_post != null) {
          _postList.add(_post);
        }
      });
      if (_postList != null) {
        _postGridList.add(_postList);
      }
    });
    notifyListeners();
  }
/* ------------------------------ End of class ------------------------------ */
}
