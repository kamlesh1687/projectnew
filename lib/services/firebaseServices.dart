import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/userModel.dart';

class FirebaseServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference collecRef =
      FirebaseFirestore.instance.collection('users');
  Future signUp(String _email, String _pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);
    } catch (e) {}
  }

  Future signIn(String _email, String _pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _pass);
    } catch (e) {}
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future createUser(UseR _user) async {
    try {
      await collecRef.doc('${_user.userId}').set(_user.toJson());
    } catch (e) {}
  }

  Future<String> getUserName(String _userId) async {
    String _name;
    DocumentSnapshot _userdata = await collecRef.doc(_userId).get();
    _name = _userdata.data()['displayName'];
    return _name;
  }

  Future<UseR> getUserData(String _userId) async {
    UseR _userData;
    try {
      await collecRef.doc(_userId).get().then((DocumentSnapshot snapshot) {
        _userData = UseR.fromJson(snapshot.data());
      });
    } catch (e) {}
    return _userData;
  }

  Future<String> uploadImg(
      String _userId, File _fileImage, StorageReference _ref) async {
    StorageUploadTask snapshot = _ref.putFile(_fileImage);
    StorageTaskSnapshot taskSnapshot = await snapshot.onComplete;

    return await taskSnapshot.ref.getDownloadURL();
  }

/* --------------------------- Post Related Query --------------------------- */
  Future uploadPost(PosT _post) async {
    collecRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .set(_post.toJson());
  }

  Future removePostFromTimeLine({String myUserId, String otherUserID}) async {
    QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserID)
        .collection('postImages')
        .get();
    print('removing');
    for (var _item in qSnap.docs) {
      String _postId = _item.id.toString();
      FirebaseFirestore.instance
          .collection('timeLine')
          .doc(myUserId)
          .collection('timeLinePosts')
          .doc(_postId)
          .delete();
    }
  }

  Future createTimeLine(UseR _user, PosT _post) async {
    DocumentSnapshot _userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.userId)
        .get();
    addPostToTimeLine(_post, _user.userId);
    List _followerList = _userDoc.data()['followersList'];
    _followerList.forEach((element) {
      addPostToTimeLine(_post, element.toString());
    });
  }

  Future addPostToTimeLine(PosT _post, String _userId) async {
    try {
      FirebaseFirestore.instance
          .collection('timeLine')
          .doc(_userId)
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

  Future<List<QueryDocumentSnapshot>> getFeedData(String _userId) async {
    QuerySnapshot _qSnap = await FirebaseFirestore.instance
        .collection('timeLine')
        .doc(_userId)
        .collection('timeLinePosts')
        .get();

    return _qSnap.docs;
  }
}
