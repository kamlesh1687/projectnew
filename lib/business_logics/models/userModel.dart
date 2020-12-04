import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String userId;
  String displayName;
  String profilePic;
  String bio;

  UserModel({
    this.email,
    this.userId,
    this.displayName,
    this.profilePic,
    this.bio,
  });

//fromDocumentSnapshot
  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    email = documentSnapshot.data()["email"];
    userId = documentSnapshot.data()["userId"];
    displayName = documentSnapshot.data()["displayName"];
    profilePic = documentSnapshot.data()["profilePic"];
    bio = documentSnapshot.data()["bio"];
  }

//toString
  @override
  String toString() {
    return '''UserModel: {email = ${this.email},userId = ${this.userId},displayName = ${this.displayName},profilePic = ${this.profilePic},bio = ${this.bio}}''';
  }

//fromJson
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userId = json['userId'];
    displayName = json['displayName'];
    profilePic = json['profilePic'];
    bio = json['bio'];
  }

//toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    data['userId'] = this.userId;
    data['displayName'] = this.displayName;
    data['profilePic'] = this.profilePic;
    data['bio'] = this.bio;
    return data;
  }
}

defaultUser({
  String userId,
  String email,
  String userName,
  String descrip,
  String urlPic,
}) {
  String _url =
      "https://tribunest.com/wp-content/uploads/2019/02/dummy-profile-image.png";
  descrip = descrip == null ? "Enter Your Bio" : descrip;
  urlPic = urlPic == null ? _url : urlPic;

  return UserModel(
    userId: userId,
    displayName: userName,
    email: email,
    bio: descrip,
    profilePic: urlPic,
  );
}
