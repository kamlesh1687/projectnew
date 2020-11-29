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
    await _auth.createUserWithEmailAndPassword(email: _email, password: _pass);
  }

  Future signIn(String _email, String _pass) async {
    await _auth.signInWithEmailAndPassword(email: _email, password: _pass);
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future createUser(UseR _user) async {
    await collecRef.doc('${_user.userId}').set(_user.toJson());
  }

  Future<UseR> getUserData(String _userId) async {
    UseR _userData;
    await collecRef.doc(_userId).get().then((DocumentSnapshot snapshot) {
      _userData = UseR.fromDocument(snapshot);
    });
    return _userData;
  }

  Future<String> uploadImg(
      String _userId, File _fileImage, StorageReference _ref) async {
    StorageUploadTask snapshot = _ref.putFile(_fileImage);
    StorageTaskSnapshot taskSnapshot = await snapshot.onComplete;

    return await taskSnapshot.ref.getDownloadURL();
  }

  Future uploadPost(PosT _post) async {
    collecRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .set(_post.toJson());
  }
}
