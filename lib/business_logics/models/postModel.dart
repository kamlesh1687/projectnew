import 'package:cloud_firestore/cloud_firestore.dart';

class PosT {
  String postimageurl;
  String postdescription;
  String postlocation;
  String ownername;
  String ownerId;
  String postId;
  var posttime;

  PosT({
    this.postimageurl,
    this.postdescription,
    this.postlocation,
    this.ownername,
    this.posttime,
    this.postId,
    this.ownerId,
  });

  factory PosT.fromDocument(DocumentSnapshot doc) {
    return PosT(
        postimageurl: doc.data()['postimageurl'],
        postdescription: doc.data()['postdescription'],
        postlocation: doc.data()['postlocation'],
        ownername: doc.data()['ownername'],
        posttime: doc.data()['posttime'],
        ownerId: doc.data()['ownerId'],
        postId: doc.data()['postId']);
  }
  toJson() {
    return {
      'postimageurl': postimageurl,
      'postdescription': postdescription,
      'postlocation': postlocation,
      'ownername': ownername,
      'ownerId': ownerId,
      'posttime': posttime,
      'postId': postId
    };
  }
}
