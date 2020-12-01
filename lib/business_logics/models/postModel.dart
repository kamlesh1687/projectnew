import 'package:cloud_firestore/cloud_firestore.dart';

class PosT {
  String postimageurl;
  String postdescription;
  String postlocation;

  String ownerId;
  String postId;
  String ownerPic;
  var posttime;

  PosT(
      {this.postimageurl,
      this.postdescription,
      this.postlocation,
      this.posttime,
      this.postId,
      this.ownerId,
      this.ownerPic});

  factory PosT.fromDocument(DocumentSnapshot doc) {
    return PosT(
        postimageurl: doc.data()['postimageurl'],
        postdescription: doc.data()['postdescription'],
        postlocation: doc.data()['postlocation'],
        posttime: doc.data()['posttime'],
        ownerId: doc.data()['ownerId'],
        postId: doc.data()['postId'],
        ownerPic: doc.data()['ownerPic']);
  }
  toJson() {
    return {
      'postimageurl': postimageurl,
      'postdescription': postdescription,
      'postlocation': postlocation,
      'ownerId': ownerId,
      'posttime': posttime,
      'postId': postId,
      'ownerPic': ownerPic
    };
  }
}
