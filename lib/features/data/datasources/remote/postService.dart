import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectnew/features/data/models/UserProfileModel.dart';
import 'package:projectnew/features/data/models/postModel.dart';

class PostService {
  PostService();
  CollectionReference feedRef = FirebaseFirestore.instance.collection('feed');

  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');

  addpost(PosT _post) async {
    postRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .set({
          "postimageurl": _post.postimageurl,
          "postdescription": _post.postdescription,
          "postlocation": _post.postlocation,
          "ownerId": _post.ownerId,
          "postId": _post.postId,
          "ownerPic": _post.ownerPic,
          "posttime": Timestamp.now(),
        })
        .then((value) => print('success'))
        .catchError((err) {
          print(err.message);
          print(err.code);
        });
  }

  updatepost(PosT _post) async {
    postRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .update({
          "postimageurl": _post.postimageurl,
          "postdescription": _post.postdescription,
          "postlocation": _post.postlocation,
          "ownerId": _post.ownerId,
          "postId": _post.postId,
          "ownerPic": _post.ownerPic,
          "posttime": _post.posttime,
        })
        .then((value) => print('success'))
        .catchError((err) {
          print(err.message);
          print(err.code);
        });
  }

  void deletePosT(PosT _post) async {
    postRef
        .doc(_post.ownerId)
        .collection('postImages')
        .doc(_post.postId)
        .delete()
        .then((value) => print('success'))
        .catchError((err) {
      print(err.message);
      print(err.code);
    });
  }

  // Future getPost() {
  //   QuerySnapshot _qSnap = await postRef
  //       .doc(uid)
  //       .collection('postImages')
  //       .where('posttime', isGreaterThanOrEqualTo: _lastHours)
  //       .get();
  // }

  Future<List<PosT>> getFeed(UseR _user) async {
    DateTime _lastHours = DateTime.now().subtract(Duration(hours: 24));
    List<PosT> _postList;

    List _list = _user.followingList;
    _list.add(_user.userId);
    _postList = [];
    print(_postList.length);
    for (var uid in _list) {
      QuerySnapshot _qSnap = await postRef
          .doc(uid)
          .collection('postImages')
          .where('posttime', isGreaterThanOrEqualTo: _lastHours)
          .get();

      for (var postDoc in _qSnap.docs) {
        PosT _post = PosT.fromDocumentSnapshot(documentSnapshot: postDoc);
        _postList.add(_post);
      }
    }
    return _postList;
  }

  Future<List<PosT>> getFeedData(String _userId) async {
    QuerySnapshot _qSnap = await feedRef
        .doc(_userId)
        .collection('feedPosts')
        .orderBy('posttime', descending: true)
        .get();
    List<PosT> _postlist = _qSnap.docs
        .map((doc) => PosT.fromDocumentSnapshot(documentSnapshot: doc))
        .toList();

    return _postlist;
  }

  Future removePostFromTimeLine({String myUserId, String otherUserID}) async {
    QuerySnapshot qSnap =
        await postRef.doc(otherUserID).collection('postImages').get();

    for (var _item in qSnap.docs) {
      String _postId = _item.id.toString();
      feedRef.doc(myUserId).collection('feedPosts').doc(_postId).delete();
    }
  }

  Future<List<QueryDocumentSnapshot>> getPostData(String _userId) async {
    QuerySnapshot _qSnap =
        await postRef.doc(_userId).collection('postImages').get();

    return _qSnap.docs;
  }

  Future createFeed(UseR _user, PosT _post) async {
    addPostToFeed(_post, _user.userId);
    List _followerList = _user.followersList;

    _followerList.forEach((element) {
      print(element.toString());
      addPostToFeed(_post, element.toString());
    });
  }

  Future addPostToFeed(PosT _post, String _userId) async {
    try {
      feedRef
          .doc(_userId)
          .collection('feedPosts')
          .doc(_post.postId)
          .set(_post.toJson());
    } catch (e) {}
  }
}
