import 'package:projectnew/features/data/models/UserProfileModel.dart';

class UserData {
  final UseR user;
  UserData({this.user});

  String get userId => user.userId;
  String get userName => user.displayName;
  String get picUrl => user.profilePic;
  String get userBio => user.bio;
  String get followerCount => user.getFollower();
  String get followingCount => user.getFollowing();
  String get postCount => user.getFollowing();
}
