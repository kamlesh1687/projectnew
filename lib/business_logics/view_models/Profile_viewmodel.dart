import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import '../appstate.dart';
import 'Feed_viewmodel.dart';

enum EventLoadingStatus { Loading, Loaded }

FeedViewModel uploadViewModel = FeedViewModel();

class ProfileViewModel extends AppState {
  String myUid = FirebaseAuth.instance.currentUser.uid;
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
/* ------------------ Declaration of variables and objects ------------------ */

  User firebaseUser = FirebaseAuth.instance.currentUser;
  CollectionReference userref = FirebaseFirestore.instance.collection('users');
  String userphotourl;
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
    print(value);
    isUpdating = value;
    notifyListeners();
  }

/* ----------------------------- Loading Status ----------------------------- */

/* ------------------------------- isMe or not ------------------------------ */

  Future getUserProfileData(String _userId) async {
    var user = FirebaseAuth.instance.currentUser;
    _userId = _userId ?? user.uid;
    _profileUserModelList = _profileUserModelList ?? [];
    UseR _userData = await firebaseServices.getUserData(_userId);
    _profileUserModelList.add(_userData);

    if (_userId == user.uid) {
      _userModel = _profileUserModelList.last;
    }

    eventLoadingStatus = EventLoadingStatus.Loaded;
    notifyListeners();
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
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

    UseR _userUpdate = UseR(
        profilePic: _picUrl,
        displayName: _userName,
        bio: _bio,
        email: _userData.email,
        userId: _userData.userId,
        followers: _userData.followers,
        following: _userData.following,
        followersList: _userData.followersList,
        followingList: _userData.followingList);
    _userModel = _userUpdate;
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

  followUser({bool removeFollower = false}) async {
    if (removeFollower) {
      profileUserModel.followersList.remove(userModel.userId);
      userModel.followingList.remove(profileUserModel.userId);
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
    }

    profileUserModel.followers = profileUserModel.followersList.length;

    userModel.following = userModel.followingList.length;
    print("followerCoount" + "${userModel.following}");

    print("profileModelUserId" + profileUserModel.followers.toString());
    firebaseServices.createUser(profileUserModel);
    firebaseServices.createUser(userModel);

    notifyListeners();
  }

/* ---------------------------- Followers Update ---------------------------- */

  isFollowed(UseR _userFromList) {
    if (_userFromList.followersList != null &&
        _userFromList.followersList.isNotEmpty) {
      return (_userFromList.followersList.any((x) => x == myUid));
    } else {
      print('not following');
      return false;
    }
  }

  followUserListBtn(UseR _userFromList, {bool removeFollower = false}) async {
    if (_userFromList.userId != myUid) {
      if (removeFollower) {
        _userFromList.followersList.remove(userModel.userId);
        userModel.followingList.remove(_userFromList.userId);
        firebaseServices.removePostFromTimeLine(
            myUserId: userModel.userId, otherUserID: _userFromList.userId);
        print("removed");
      } else {
        if (_userFromList.followersList == null) {
          _userFromList.followersList = [];
        }
        _userFromList.followersList.add(userModel.userId);

        if (userModel.followingList == null) {
          userModel.followingList = [];
        }
        userModel.followingList.add(_userFromList.userId);
      }

      _userFromList.followers = _userFromList.followersList.length;

      userModel.following = userModel.followingList.length;

      firebaseServices.createUser(_userFromList);
      firebaseServices.createUser(userModel);
    }

    notifyListeners();
  }

/* ------------------------------ End of class ------------------------------ */
}

// try {
//   // final updateWithTimestamp = <String, dynamic>{
//   //   'data': FieldValue.arrayUnion(profileUserModel.followersList)
//   // };

//   // FirebaseFirestore.instance
//   //     .collection('users')
//   //     .doc(profileUserModel.userId)
//   //     .collection('FOLLOWER_COLLECTION')
//   //     .doc('FOLLOWER_COLLECTION')
//   //     .set(updateWithTimestamp);

//   // FirebaseFirestore.instance
//   //     .collection('users')
//   //     .doc(userModel.userId)
//   //     .collection('FOLLOWING_COLLECTION')
//   //     .doc('FOLLOWING_COLLECTION')
//   //     .set({'data': FieldValue.arrayUnion(userModel.followingList)});

// } catch (e) {
//   print(
//     e,
//   );
// }
