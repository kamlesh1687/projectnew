import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectnew/business_logics/models/feedModel.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import 'package:uuid/uuid.dart';

import '../appstate.dart';

enum FeedLoadingStatus { Loading, Loaded }

class FeedViewModel extends AppState {
/* ------------------ Declaration of variables and objects ------------------ */

  FirebaseStorage _storage = FirebaseStorage.instance;

  File _fileImage;

  bool isLoading = false;

/* ------------------------------- All Getters ------------------------------ */

  get fileImage => _fileImage;

/* ------------------------------- All Setters ------------------------------ */

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
    isUpLoading(true);
    String _postId = Uuid().v4();
    StorageReference _storeRef =
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

      firebaseServices.uploadPost(_postData).then((value) {
        print(_postData.postimageurl);
        firebaseServices.createTimeLine(userDta, _postData);
        addOwnFeed(_postData, userDta);
        removeImage();
        isUpLoading(false);
      });
    });
  }

  Future addOwnFeed(PosT _post, UseR _user) async {
    FeeD _feed = FeeD(
      displayName: _user.displayName,
      location: _post.postlocation,
      ownerId: _user.userId,
      postCaption: _post.postdescription,
      postUrl: _post.postimageurl,
      profileUrl: _user.profilePic,
    );
    print(feedList.length);
    feedList.add(_feed);
  }

/* -------------------------------- Feed Data ------------------------------- */
  FeedLoadingStatus _feedLoadingStatus = FeedLoadingStatus.Loading;
  get feedLoadingStatus => _feedLoadingStatus;
  set feedLoadingStatus(value) {
    _feedLoadingStatus = value;
    notifyListeners();
  }

  List<FeeD> feedList;

  Future createFeed(String _userId) async {
    feedList = [];
    await firebaseServices.getFeedData(_userId).then((docs) {
      docs.forEach((element) async {
        String _ownerId = element.data()['ownerId'];
        print("ownerId" + _ownerId);
        firebaseServices.getUserData(_ownerId).then((_userData) {
          FeeD _feed = FeeD(
              postUrl: element.data()['postimageurl'],
              location: element.data()['postlocation'],
              displayName: _userData.displayName,
              ownerId: _ownerId,
              postCaption: element.data()['postdescription'],
              profileUrl: _userData.profilePic);

          feedList.add(_feed);
          feedLoadingStatus = FeedLoadingStatus.Loaded;
          notifyListeners();
        });
      });
    });
  }
}
