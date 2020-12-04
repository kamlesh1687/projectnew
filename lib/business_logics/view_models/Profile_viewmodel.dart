import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import '../appstate.dart';

enum EventLoadingStatus { Loading, Loaded }

class ProfileViewModel extends AppState {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  List<UseR> _profileUserModelList;
  UseR _userModel;
  String postCount;

  List<List<PosT>> _postGridList;

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
/* ------------------ Declaration of variables and objects ------------------ */

  File _fileImage;

  bool isUpdating = false;
  EventLoadingStatus _eventLoadingStatus = EventLoadingStatus.Loading;
/* ------------------------------- All Getters ------------------------------ */

  get fileImage => _fileImage;
  get eventLoadingStatus => _eventLoadingStatus;
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
  followUser({bool removeFollower = false}) async {
    if (removeFollower) {
      profileUserModel.followersList.remove(userModel.userId);
      userModel.followingList.remove(profileUserModel.userId);
      firebaseServices.unFollowUser(userModel.userId, profileUserModel.userId);
      firebaseServices.removePostFromTimeLine(
          myUserId: userModel.userId, otherUserID: profileUserModel.userId);
      print("removed");
    } else {
      if (profileUserModel.followersList == null) {
        profileUserModel.followersList = [];
      }
      profileUserModel.followersList.add(userModel.userId);
      print('added');
      print("getting userModelfollowing " + "${userModel.followersList}");
      if (userModel.followingList == null) {
        userModel.followingList = [];
      }
      userModel.followingList.add(profileUserModel.userId);
      firebaseServices.followUser(userModel.userId, profileUserModel.userId);
    }

    profileUserModel.followers = profileUserModel.followersList.length;

    userModel.following = userModel.followingList.length;
    print("followerCoount" + "${userModel.following}");

    print("profileModelUserId" + profileUserModel.followers.toString());

    notifyListeners();
  }

/* ------------------------------- isMe or not ------------------------------ */

  Future getUserProfileData(String _userId) async {
    _userId = _userId ?? myUid;
    _profileUserModelList = _profileUserModelList ?? [];
    List<String> _followersList = [];
    List<String> _followingList = [];

    UserModel _userData = await firebaseServices.getUserData(_userId);
    await firebaseServices
        .getFollowersList(_userId)
        .then((value) => {
              value.forEach((element) {
                _followersList.add(element.id);
              })
            })
        .then((value) {});
    await firebaseServices.getFollowingList(_userId).then((value) => {
          value.forEach((element) {
            _followingList.add(element.id);
          })
        });
    print(_followersList.length);
    print(_followingList.length);

    UseR _profileUser = UseR(
        bio: _userData.bio,
        email: _userData.email,
        displayName: _userData.displayName,
        followers: _followersList.length ?? 0,
        followersList: _followersList,
        following: _followingList.length ?? 0,
        followingList: _followingList,
        profilePic: _userData.profilePic,
        userId: _userData.userId);

    _profileUserModelList.add(_profileUser);

    if (_userId == myUid) {
      _userModel = _profileUserModelList.last;
    }
    getUserPost(_userId).then((value) {
      postGridView(_userId).then((value) {
        eventLoadingStatus = EventLoadingStatus.Loaded;
        notifyListeners();
      });
    });
  }

  Future otheUserProfileData(UserModel _userData) async {
    List<String> _followersList = [];
    List<String> _followingList = [];

    await firebaseServices.getFollowersList(_userData.userId).then((value) => {
          value.forEach((element) {
            _followersList.add(element.id);
          })
        });
    await firebaseServices.getFollowingList(_userData.userId).then((value) => {
          value.forEach((element) {
            _followingList.add(element.id);
          })
        });
    print(_followersList.length);
    print(_followingList.length);
    UseR _profileUser = UseR(
        bio: _userData.bio,
        email: _userData.email,
        displayName: _userData.displayName,
        followers: _followersList.length ?? 0,
        followersList: _followersList,
        following: _followingList.length ?? 0,
        followingList: _followingList,
        profilePic: _userData.profilePic,
        userId: _userData.userId);

    _profileUserModelList.add(_profileUser);

    print("trying to user given User data");
    getUserPost(_userData.userId).then((value) {
      postGridView(_userData.userId).then((value) {
        eventLoadingStatus = EventLoadingStatus.Loaded;
        notifyListeners();
      });
    });
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
    _postGridList.removeLast();
  }

  Future updateProfile(UseR _userData, String _bio, String _userName) async {
    String _picUrl;
    StorageReference _storeRef = FirebaseStorage.instance.ref().child(
        'users/${_userData.userId}/userProfile/images/${_userData.userId}');

    _picUrl = fileImage == null
        ? _userData.profilePic
        : await firebaseServices.uploadImg(
            _userData.userId, fileImage, _storeRef);
    _bio = _bio == "" ? _userData.bio : _bio;
    _userName = _userName == "" ? _userData.displayName : _userName;

    UserModel _userUpdate = UserModel(
      profilePic: _picUrl,
      displayName: _userName,
      bio: _bio,
      email: _userData.email,
      userId: _userData.userId,
    );
    _userModel = UseR(
        bio: _userUpdate.bio,
        displayName: _userUpdate.displayName,
        followers: _userModel.followers,
        email: _userModel.email,
        followersList: _userModel.followersList,
        following: _userData.following,
        followingList: _userData.followingList,
        profilePic: _userUpdate.profilePic,
        userId: _userModel.userId);
    if (_profileUserModelList != null) {
      _profileUserModelList.last = _userModel;
    }
    firebaseServices.createUser(_userUpdate);
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

  Future deleteFile() async {
    fileImage = null;
  }

  Future getUserPost(String _userId) async {
    List<QueryDocumentSnapshot> _postList =
        await firebaseServices.getPostData(_userId);
    postCount = _postList.length.toString();
    notifyListeners();
  }

  Future postGridView(_userId) async {
    _postGridList = _postGridList ?? [];

    List<PosT> _postList = [];

    await firebaseServices.getPostData(_userId).then((value) {
      print("getting Post");
      value.forEach((element) {
        PosT _post = PosT.fromDocument(element);
        _postList.add(_post);
      });
      _postGridList.add(_postList);
    });
    notifyListeners();
  }
/* ------------------------------ End of class ------------------------------ */
}
