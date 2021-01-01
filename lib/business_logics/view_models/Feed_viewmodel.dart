import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/services/firebaseServices.dart';
import 'package:uuid/uuid.dart';

import '../../ui/screens/appstate.dart';

// ProfileViewModel _profileViewModel = ProfileViewModel();
enum EventLoadingStatus { Loading, Loaded }
FirebaseServices firebaseServices = FirebaseServices();

class FeedViewModel extends AppState {
/* ------------------ Declaration of variables and objects ------------------ */
  EventLoadingStatus _feedLoadingStatus = EventLoadingStatus.Loading;
  FirebaseStorage _storage = FirebaseStorage.instance;
  ScrollController scrollController = ScrollController();

  File _fileImage;

  bool isLoading = false;

/* ------------------------------- All Getters ------------------------------ */

  get fileImage => _fileImage;

  get feedLoadingStatus => _feedLoadingStatus;

  DateTime time;
  DateTime get gettime => time;
  setTime() {
    time = DateTime.now();
    notifyListeners();
  }
/* ------------------------------- All Setters ------------------------------ */

  set feedLoadingStatus(value) {
    _feedLoadingStatus = value;
    notifyListeners();
  }

  set fileImage(_value) {
    _fileImage = _value;
    notifyListeners();
  }

  isUpLoading(value) {
    isLoading = value;
    notifyListeners();
  }
/* ------------------------------ Image picker ------------------------------ */

  pickImageFromGallery() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (_imagefile != null) {
      showUploadScreen(File(_imagefile.path));
    } else {
      fileImage = null;
    }
  }

  takeImageFromCamera() async {
    final _picker = ImagePicker();
    var _imagefile = await _picker.getImage(source: ImageSource.camera);
    if (_imagefile != null) {
      showUploadScreen(File(_imagefile.path));
    } else {
      fileImage = null;
    }
  }

/* ------------------------------ ImageCropper ------------------------------ */
  showUploadScreen(filepath) async {
    fileImage = await cropImage(filepath);
  }

  cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path, compressQuality: 30);

    return croppedImage;
  }

  removeImage() async {
    fileImage = null;
  }

/* -------------------- Image Upload To Firebase Storage -------------------- */

  Future createPost({String caption, String location, UseR userDta}) async {
    loading = true;
    isUpLoading(true);
    String _postId = Uuid().v4();

    Reference _storeRef =
        _storage.ref().child("users/${userDta.userId}/posts/images/$_postId");
    await firebaseServices
        .uploadImg(userDta.userId, fileImage, _storeRef)
        .then((imageUrl) {
      PosT _postData = PosT(
          ownerId: userDta.userId,
          postimageurl: imageUrl,
          postdescription: caption,
          postlocation: location,
          postId: _postId,
          ownerPic: userDta.profilePic,
          posttime: DateTime.now());
      _postId = null;
      feedList.add(_postData);
      notifyListeners();
      firebaseServices.uploadPost(_postData).then((value) {
        firebaseServices.createFeed(userDta, _postData);

        removeImage();
        loading = false;
        isUpLoading(false);
      });
    });
  }

/* -------------------------------- Feed Data ------------------------------- */

  List<PosT> feedList;
  resetData() {
    feedList = null;
    notifyListeners();
  }

  createFeed(_userId) async {
    print('creating feed');

    feedList = [];
    feedList = await firebaseServices.getFeedData(_userId);
    feedList.sort((b, a) {
      return a.posttime.toString().compareTo(b.posttime.toString());
    });
    feedLoadingStatus = EventLoadingStatus.Loaded;
    notifyListeners();
  }

  PageController pageController = PageController(initialPage: 0);
}
