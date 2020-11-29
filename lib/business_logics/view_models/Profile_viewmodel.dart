import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import '../appstate.dart';

enum EventLoadingStatus { Loading, Loaded }

class ProfileViewModel extends AppState {
  List<UseR> _profileUserModelList;
  UseR _userModel;

  UseR get userModel => _userModel;
  set userModel(_value) {
    _userModel = _value;
    notifyListeners();
  }

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

/* ------------------------------- All Getters ------------------------------ */

  get fileImage => _fileImage;

/* ------------------------------- All Setters ------------------------------ */
  set fileImage(value) {
    _fileImage = value;
    notifyListeners();
  }

  void updating(value) {
    print(value);
    isUpdating = value;
    notifyListeners();
  }

/* ----------------------------- Loading Status ----------------------------- */
  EventLoadingStatus _eventLoadingStatus = EventLoadingStatus.Loading;
  get eventLoadingStatus => _eventLoadingStatus;
  set eventLoadingStatus(value) {
    _eventLoadingStatus = value;
    notifyListeners();
  }

  Future setLoadingStatus(value) async {
    eventLoadingStatus = value;
  }

/* ------------------------------- isMe or not ------------------------------ */

  Future getUserProfileData(String _userId) async {
    var user = FirebaseAuth.instance.currentUser;
    _userId = _userId ?? user.uid;
    _profileUserModelList = _profileUserModelList ?? [];
    UseR _userData = await firebaseServices.getUserData(_userId);
    _profileUserModelList.add(_userData);
    if (_userId == user.uid) {
      userModel = _profileUserModelList.last;
    }
    eventLoadingStatus = EventLoadingStatus.Loaded;
    notifyListeners();
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
  }

  Future updateProfile(UseR _userData, String _bio, String _userName) async {
    String _picUrl;
    StorageReference _storeRef = FirebaseStorage.instance
        .ref()
        .child("users")
        .child(_userData.userId)
        .child('userProfile')
        .child("images/${_userData.userId}");
    _picUrl = fileImage == null
        ? _userData.photoUrl
        : await firebaseServices.uploadImg(
            _userData.userId, fileImage, _storeRef);
    _bio = _bio == "" ? _userData.userDescription : _bio;
    _userName = _userName == "" ? _userData.displayName : _userName;

    UseR _userUpdate = UseR(
        photoUrl: _picUrl,
        displayName: _userName,
        userDescription: _bio,
        userEmail: _userData.userEmail,
        userId: _userData.userId);
    userModel = _userUpdate;
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

  Stream getFollowCount(var userId, var collection) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc('$userId')
          .collection(collection)
          .snapshots();

  Stream getFollowState(var otherUserId, var userId) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc('$otherUserId')
          .collection('followerList')
          .doc('$userId')
          .snapshots();
/* ---------------------------- Followers Update ---------------------------- */
  Future updateFollowers(String _userId, String otherUserId) async {
    print(FirebaseAuth.instance.currentUser.uid);

    print("Other user Id" + otherUserId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$otherUserId')
        .collection('followerList')
        .doc('$_userId')
        .set({});
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$_userId')
        .collection('followingList')
        .doc('$otherUserId')
        .set({});
    print('Followers Updated');
  }

  Future removeFollower(var _userId, var otherUserId) async {
    print('Started Updating Followers');
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$otherUserId')
        .collection('followerList')
        .doc('$_userId')
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$_userId')
        .collection('followingList')
        .doc('$otherUserId')
        .delete();
    print('Followers Updated');
  }

/* ------------------------------ End of class ------------------------------ */
}
