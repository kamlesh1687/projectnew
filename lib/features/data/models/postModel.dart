import 'package:cloud_firestore/cloud_firestore.dart';

class PosT {
  String postimageurl;
  String postdescription;
  String postlocation;
  String ownerId;
  String postId;
  String ownerPic;
  Timestamp posttime;

  PosT({
    this.postimageurl,
    this.postdescription,
    this.postlocation,
    this.ownerId,
    this.postId,
    this.ownerPic,
    this.posttime,
  });

//fromDocumentSnapshot
  PosT.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    postimageurl = documentSnapshot.data()["postimageurl"];
    postdescription = documentSnapshot.data()["postdescription"];
    postlocation = documentSnapshot.data()["postlocation"];
    ownerId = documentSnapshot.data()["ownerId"];
    postId = documentSnapshot.data()["postId"];
    ownerPic = documentSnapshot.data()["ownerPic"];
    posttime = documentSnapshot.data()["posttime"];
  }

//toString
  @override
  String toString() {
    return '''PosT: {postimageurl = ${this.postimageurl},postdescription = ${this.postdescription},postlocation = ${this.postlocation},ownerId = ${this.ownerId},postId = ${this.postId},ownerPic = ${this.ownerPic},posttime = ${this.posttime}}''';
  }

//fromJson
  PosT.fromJson(Map<String, dynamic> json) {
    postimageurl = json['postimageurl'];
    postdescription = json['postdescription'];
    postlocation = json['postlocation'];
    ownerId = json['ownerId'];
    postId = json['postId'];
    ownerPic = json['ownerPic'];
    posttime = json['posttime'];
  }

//toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['postimageurl'] = this.postimageurl;
    data['postdescription'] = this.postdescription;
    data['postlocation'] = this.postlocation;
    data['ownerId'] = this.ownerId;
    data['postId'] = this.postId;
    data['ownerPic'] = this.ownerPic;
    data['posttime'] = this.posttime;
    return data;
  }
}
