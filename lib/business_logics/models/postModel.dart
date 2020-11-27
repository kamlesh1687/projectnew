import 'package:cloud_firestore/cloud_firestore.dart';

PosT currentPost;

class PosT {
  final String postimageurl;
  final String postdescription;
  final String postlocation;
  final String ownername;
  final String ownerId;
  var posttime;

  PosT({
    this.postimageurl,
    this.postdescription,
    this.postlocation,
    this.ownername,
    this.posttime,
    this.ownerId,
  });

  factory PosT.fromDocument(DocumentSnapshot doc) {
    return PosT(
        postimageurl: doc.data()['postimageurl'],
        postdescription: doc.data()['postdescription'],
        postlocation: doc.data()['postlocation'],
        ownername: doc.data()['ownername'],
        posttime: doc.data()['posttime'],
        ownerId: doc.data()['ownerId']);
  }
}
