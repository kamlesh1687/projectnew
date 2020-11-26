class UseR {
  final String userEmail;
  final String userId;
  final String displayName;
  final String userDescription;
  final String photoUrl;

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
}
