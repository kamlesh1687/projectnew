import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';

import '../appstate.dart';

class UploadScreenViewModel extends AppState {
/* ------------------ Declaration of variables and objects ------------------ */
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;
  var userref = FirebaseFirestore.instance.collection('users');
  File _fileImage;
  String postUrl;
  String postId;
  String userId;

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
  Future updateImageToStorage() async {
    isLoading = true;
    String userName = await userref
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.data()['displayName'];
    });
    postId = Uuid().v4();
    var _reference = _storage
        .ref()
        .child("users")
        .child(userId)
        .child('posts')
        .child("images/$postId");
    StorageUploadTask snapshot = _reference.putFile(fileImage);
    StorageTaskSnapshot taskSnapshot = await snapshot.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      postUrl = value;

      print("Image uploaded");
      uploadPostDataTofirebase(userName);
    });
  }

/* ------------------------------ UploadPostData----------------------------- */

  Future uploadPostDataTofirebase(userName) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('postImages')
          .doc(postId)
          .set({
        'ownername': userName,
        'ownerId': userId,
        'postimageurl': postUrl,
        'postdescription': captionController.text,
        'postlocation': locationController.text,
        'posttime': DateTime.now()
      }).then((value) {
        createTimeLine(userName).then((value) {
          captionController.clear();
          locationController.clear();
          fileImage = null;
          isLoading = false;
          postId = null;
        });

        print("Uploaded");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future createTimeLine(userName) async {
    try {
      FirebaseFirestore.instance
          .collection('timeLine')
          .doc(userId)
          .collection('timeLinePosts')
          .doc(postId)
          .set({
        'ownername': userName,
        'ownerId': userId,
        'postimageurl': postUrl,
        'postdescription': captionController.text,
        'postlocation': locationController.text,
        'posttime': DateTime.now()
      }).then((value) {
        print('TimeLine created Succesfully');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
