import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/data/models/userProfile.dart';

CollectionReference userRef = FirebaseFirestore.instance.collection('users');

CollectionReference followingRef =
    FirebaseFirestore.instance.collection('following');

class UserService {
  Future<ErrorHandle<UseR>> createUser(
    bio,
    userName,
  ) async {
    User user = FirebaseAuth.instance.currentUser;
    UseR _newUser = defaultUser(
        email: user.email, userId: user.uid, userName: userName, bio: bio);
    try {
      return await userRef
          .doc('${user.uid}')
          .set(_newUser.toJson())
          .then((value) {
        return ErrorHandle.noError<UseR>(_newUser);
      });
    } catch (e) {
      return ErrorHandle.onError(e.toString());
    }
  }

  Future<ErrorHandle<UseR>> updateUser(
    UseR userData,
  ) async {
    try {
      return await userRef
          .doc('${userData.userId}')
          .set(userData.toJson())
          .then((value) {
        return ErrorHandle.noError<UseR>(userData);
      });
    } catch (e) {
      return ErrorHandle.onError(e.toString());
    }
  }

  /// Get user data from friebase
  Future<ErrorHandle<UseR>> getUser(String _userId) async {
    try {
      return await userRef.doc(_userId).get().then((DocumentSnapshot snapshot) {
        return ErrorHandle.noError<UseR>(UseR.fromJson(snapshot.data()));
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      return ErrorHandle.onError(e.toString());
    }
  }

  Future<ErrorHandle<ProfileUser>> getUserProfile(_userId, {myUserId}) async {
    try {
      ProfileUser profileUser;
      UseR _useR =
          await userRef.doc(_userId).get().then((DocumentSnapshot snapshot) {
        return UseR.fromJson(snapshot.data());
      });
      _useR.followersList = [];
      _useR.followingList = [];
      _useR.followersList = await getFollowersList(_userId);
      _useR.followingList = await getFollowingList(_userId);
      _useR.followers = _useR.followersList.length.toInt();
      _useR.following = _useR.followingList.length.toInt();
      profileUser = ProfileUser(userData: _useR);
      return ErrorHandle.noError<ProfileUser>(profileUser);
    } on FirebaseException catch (e) {
      print(e.toString());
      return ErrorHandle.onError(e.toString());
    }
  }

/* --------------------------- Post Related Query --------------------------- */

  Stream searchUserStream(String keyword) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: keyword)
        .snapshots();
  }

  Future<bool> getFollowStatus(_myUid, _otherUid) async {
    DocumentSnapshot _followDocs = await followingRef
        .doc(_myUid)
        .collection('following')
        .doc(_otherUid)
        .get();
    return _followDocs.exists;
  }

  Future<List<String>> getFollowersList(String _userId) async {
    final List<String> _data = [];
    print(_userId);
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
    print(_data.length);
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
