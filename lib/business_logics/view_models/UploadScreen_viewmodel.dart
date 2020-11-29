import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import 'package:uuid/uuid.dart';

import '../appstate.dart';

class UploadScreenViewModel extends AppState {
/* ------------------ Declaration of variables and objects ------------------ */

  FirebaseStorage _storage = FirebaseStorage.instance;
  var userref = FirebaseFirestore.instance.collection('users');
  File _fileImage;

  bool isLoading = false;

/* ------------------------------- All Getters ------------------------------ */

  get fileImage => _fileImage;

/* ------------------------------- All Setters ------------------------------ */

  set fileImage(_value) {
    _fileImage = _value;
    notifyListeners();
  }

  set iSLoading(value) {
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

  Future createPost(String _caption, String _location, UseR _userData) async {
    isLoading = true;
    String _postId = Uuid().v4();
    StorageReference _storeRef = _storage
        .ref()
        .child("users")
        .child(_userData.userId)
        .child('posts')
        .child("images/$_postId");
    String _postUrl = await firebaseServices.uploadImg(
        _userData.userId, fileImage, _storeRef);

    PosT _postData = PosT(
        ownername: _userData.displayName,
        ownerId: _userData.userId,
        postimageurl: _postUrl,
        postdescription: _caption,
        postlocation: _location,
        postId: _postId,
        posttime: DateTime.now());
    _postId = null;
    fileImage = null;

    firebaseServices.uploadPost(_postData).then((value) {
      createTimeLine(_postData).then((value) {
        isLoading = false;
      });
    });
  }

/* ------------------------------ UploadPostData----------------------------- */

  Future createTimeLine(PosT _post) async {
    try {
      FirebaseFirestore.instance
          .collection('timeLine')
          .doc(_post.ownerId)
          .collection('timeLinePosts')
          .doc(_post.postId)
          .set(_post.toJson())
          .then((value) {
        print('TimeLine created Succesfully');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
