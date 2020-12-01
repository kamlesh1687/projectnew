import 'package:cloud_firestore/cloud_firestore.dart';

class FeeD {
  String profileUrl;
  String displayName;
  String postUrl;
  String ownerId;
  String postCaption;
  String location;

  FeeD({
    this.profileUrl,
    this.displayName,
    this.postUrl,
    this.ownerId,
    this.postCaption,
    this.location,
  });

//fromDocumentSnapshot
  FeeD.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    profileUrl = documentSnapshot.data()["profileUrl"];
    displayName = documentSnapshot.data()["displayName"];
    postUrl = documentSnapshot.data()["postUrl"];
    ownerId = documentSnapshot.data()["ownerId"];
    postCaption = documentSnapshot.data()["postCaption"];
    location = documentSnapshot.data()["location"];
  }

//toString
  @override
  String toString() {
    return '''FeeD: {profileUrl = ${this.profileUrl},displayName = ${this.displayName},postUrl = ${this.postUrl},ownerId = ${this.ownerId},postCaption = ${this.postCaption},location = ${this.location}}''';
  }

//fromJson
  FeeD.fromJson(Map<String, dynamic> json) {
    profileUrl = json['profileUrl'];
    displayName = json['displayName'];
    postUrl = json['postUrl'];
    ownerId = json['ownerId'];
    postCaption = json['postCaption'];
    location = json['location'];
  }

//toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileUrl'] = this.profileUrl;
    data['displayName'] = this.displayName;
    data['postUrl'] = this.postUrl;
    data['ownerId'] = this.ownerId;
    data['postCaption'] = this.postCaption;
    data['location'] = this.location;
    return data;
  }
}
