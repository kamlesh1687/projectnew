class UseR {
  String userEmail;
  String userId;
  String displayName;
  String userDescription;
  String photoUrl;

  UseR(
      {this.userEmail,
      this.userId,
      this.displayName,
      this.userDescription,
      this.photoUrl});

  factory UseR.fromDocument(doc) {
    return UseR(
        userEmail: doc.data()['userEmail'],
        userId: doc.data()['userId'],
        displayName: doc.data()['displayName'],
        userDescription: doc.data()['userDescription'],
        photoUrl: doc.data()['photoUrl']);
  }

  toJson() {
    return {
      'userEmail': userEmail,
      'displayName': displayName,
      'userDescription': userDescription,
      'userId': userId,
      'photoUrl': photoUrl
    };
  }
}

defaultUser(
    {String userId,
    String email,
    String userName,
    String descrip,
    String urlPic}) {
  String _url =
      "https://tribunest.com/wp-content/uploads/2019/02/dummy-profile-image.png";
  descrip = descrip == null ? "Enter Your Bio" : descrip;
  urlPic = urlPic == null ? _url : urlPic;
  return UseR(
      userId: userId,
      displayName: userName,
      userEmail: email,
      userDescription: descrip,
      photoUrl: urlPic);
}
