import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/utils/models/userModel.dart';

enum EventLoadingStatus { Loading, Loaded }

class ProfileViewModel extends ChangeNotifier {
/* ------------------ Declaration of variables and objects ------------------ */

  TextEditingController userNameEditCotroller = TextEditingController();
  TextEditingController userDescriptionEditCotroller = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  CollectionReference userref = FirebaseFirestore.instance.collection('users');
  String _userphotourl;
  File _fileImage;
  UseR _userProfileData;
  UseR _otherUserData;

  bool isUpdatingData = false;
/* ------------------------------- All Getters ------------------------------ */
  get userProfileData => _userProfileData;
  get fileImage => _fileImage;

/* ------------------------------- All Setters ------------------------------ */
  set fileImage(value) {
    _fileImage = value;
    notifyListeners();
  }

  set userProfileData(value) {
    _userProfileData = value;
    notifyListeners();
  }

  set otherUserData(value) {
    _otherUserData = value;
    notifyListeners();
  }

  set isUpdating(value) {
    isUpdatingData = value;
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

/* --------------------------- Getdatafromfirebase -------------------------- */
  Future<void> getdatafromfirebase(var _userid, bool isCurrentUser) async {
    print("Started");
    print(isCurrentUser);
    await userref.doc(_userid).get().then((DocumentSnapshot documentSnapshot) {
      userProfileData = UseR.fromDocument(documentSnapshot);
    }).then((value) {
      eventLoadingStatus = EventLoadingStatus.Loaded;
    });
  }

/* -------------------------- Streams  -------------------------- */

  Future getuserdata(var _userId) {
    return FirebaseFirestore.instance.collection('users').doc(_userId).get();
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
  Future updateFollowers(var _userId, var otherUserId) async {
    print('Started Updating Followers');
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

/* -------------------------- UpdateDataTofirebase -------------------------- */
  Future updateDataTofirebase(var _userID, var currentUser) async {
    try {
      FirebaseFirestore.instance.collection('users').doc('$_userID').update({
        'displayName': userNameEditCotroller.text == ""
            ? currentUser.displayName
            : userNameEditCotroller.text,
        'userDescription': userDescriptionEditCotroller.text == ""
            ? currentUser.userDescription
            : userDescriptionEditCotroller.text,
        'photoUrl':
            _userphotourl == null ? currentUser.photoUrl : _userphotourl,
      }).then((value) {
        userDescriptionEditCotroller.clear();
        userNameEditCotroller.clear();
        fileImage = null;
      });
    } catch (e) {
      print(e.toString());
    }
  }

/* --------------------------------- logout --------------------------------- */
  logout() {
    FirebaseAuth.instance.signOut();
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
  Future updateImageToStorage(var _userId) async {
    eventLoadingStatus = EventLoadingStatus.Loading;
    var _reference = _storage
        .ref()
        .child("users")
        .child(_userId)
        .child('userProfile')
        .child("images/$_userId");
    StorageUploadTask snapshot = _reference.putFile(fileImage);
    StorageTaskSnapshot taskSnapshot = await snapshot.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((value) {
      _userphotourl = value;
    });
  }
/* ------------------------------ End of class ------------------------------ */
}
