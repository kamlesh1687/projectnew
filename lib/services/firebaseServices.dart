import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future updateUserData(UseR _user) async {
    await collecRef.doc('${_user.userId}').update(_user.toJson());
  }
}
