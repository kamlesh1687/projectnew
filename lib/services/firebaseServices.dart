import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference userRef = FirebaseFirestore.instance.collection('users');
CollectionReference feedRef = FirebaseFirestore.instance.collection('feed');
CollectionReference postRef = FirebaseFirestore.instance.collection('posts');
CollectionReference followingRef =
    FirebaseFirestore.instance.collection('following');

class FirebaseServices {
  Future<UserCredential> signUp(String _email, String _pass) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: _email, password: _pass);

    return result;
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
      await userRef.doc('${_user.userId}').set(_user.toJson());
    } catch (e) {}
  }

  Future<UseR> getUserData(String _userId) async {
    UseR _userData;
    try {
      await userRef.doc(_userId).get().then((DocumentSnapshot snapshot) {
        _userData = UseR.fromJson(snapshot.data());
      });
    } catch (e) {}
    return _userData;
  }

  Future<String> uploadImg(
      String _userId, File _fileImage, StorageReference _ref) async {
    StorageUploadTask snapshot = _ref.putFile(_fileImage);
    StorageTaskSnapshot taskSnapshot = await snapshot.onComplete;
    String _url = await taskSnapshot.ref.getDownloadURL();
    return _url;
  }

/* --------------------------- Post Related Query --------------------------- */
  Future uploadPost(PosT _post) async {
    postRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .set(_post.toJson());
  }

  Future removePostFromTimeLine({String myUserId, String otherUserID}) async {
    QuerySnapshot qSnap =
        await postRef.doc(otherUserID).collection('postImages').get();

    for (var _item in qSnap.docs) {
      String _postId = _item.id.toString();
      feedRef.doc(myUserId).collection('feedPosts').doc(_postId).delete();
    }
  }

  Future createFeed(UseR _user, PosT _post) async {
    addPostToFeed(_post, _user.userId);
    List _followerList = _user.followersList;
    _followerList.forEach((element) {
      addPostToFeed(_post, element.toString());
    });
  }

  Future addPostToFeed(PosT _post, String _userId) async {
    try {
      feedRef
          .doc(_userId)
          .collection('feedPosts')
          .doc(_post.postId)
          .set(_post.toJson())
          .then((value) {});
    } catch (e) {}
  }

  Future<List<QueryDocumentSnapshot>> getFeedData(String _userId) async {
    QuerySnapshot _qSnap =
        await feedRef.doc(_userId).collection('feedPosts').get();

    return _qSnap.docs;
  }

  Future<List<QueryDocumentSnapshot>> getPostData(String _userId) async {
    QuerySnapshot _qSnap =
        await postRef.doc(_userId).collection('postImages').get();

    return _qSnap.docs;
  }

  Future<bool> getFollowStatus(_myUid, _otherUid) async {
    DocumentSnapshot _followDocs = await followingRef
        .doc(_myUid)
        .collection('followeing')
        .doc(_otherUid)
        .get();
    return _followDocs.exists;
  }

  Future<List<String>> getFollowersList(String _userId) async {
    final List<String> _data = [];
    QuerySnapshot _qSnap =
        await followingRef.doc(_userId).collection('followers').get();
    _qSnap.docs.forEach((_docs) {
      _data.add(_docs.id);
    });
    return _data;
  }

  Future<List<String>> getFollowingList(String _userId) async {
    final List<String> _data = [];
    QuerySnapshot _qSnap =
        await followingRef.doc(_userId).collection('following').get();
    _qSnap.docs.forEach((_docs) {
      _data.add(_docs.id);
    });
    return _data;
  }

  Future followUser(String _myUid, String _otherUid) async {
    followingRef.doc(_otherUid).collection('followers').doc(_myUid).set({});
    followingRef.doc(_myUid).collection('following').doc(_otherUid).set({});
  }

  Future unFollowUser(String _myUid, String _otherUid) async {
    followingRef.doc(_otherUid).collection('followers').doc(_myUid)..delete();
    followingRef.doc(_myUid).collection('following').doc(_otherUid).delete();
  }
}
