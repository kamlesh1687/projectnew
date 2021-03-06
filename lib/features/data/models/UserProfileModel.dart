class UseR {
  String email;
  String userId;
  String displayName;
  String profilePic;
  String bio;
  int followers;
  int following;
  int postcount;
  List<String> followersList;
  List<String> followingList;

  UseR(
      {this.email,
      this.userId,
      this.displayName,
      this.profilePic,
      this.bio,
      this.followers,
      this.following,
      this.followersList,
      this.postcount,
      this.followingList});

  UseR.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    if (followersList == null) {
      followersList = [];
    }
    if (followersList == null) {
      followingList = [];
    }
    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];

    bio = map['bio'];

    followers = map['followers'];
    following = map['following'];
    postcount = map['postcount'];

    if (map['followersList'] != null) {
      followersList = List<String>();
      map['followersList'].forEach((value) {
        followersList.add(value);
      });
    }
    followers = followersList != null ? followersList.length : null;
    if (map['followingList'] != null) {
      followingList = List<String>();
      map['followingList'].forEach((value) {
        followingList.add(value);
      });
    }
    following = followingList != null ? followingList.length : null;
  }
  toJson() {
    return {
      "email": email,
      'displayName': displayName,
      'userId': userId,
      'profilePic': profilePic,
      'bio': bio,
      'followers': followersList != null ? followersList.length : null,
      'following': followingList != null ? followingList.length : null,
      'followersList': followersList,
      'followingList': followingList
    };
  }

  UseR copyWith(
      {String email,
      String userId,
      String displayName,
      String profilePic,
      String bio,
      int followers,
      int following,
      int postcount,
      List<String> followingList,
      List<String> followersList}) {
    return UseR(
      email: email ?? this.email,
      bio: bio ?? this.bio,
      displayName: displayName ?? this.displayName,
      followers: followersList != null ? followersList.length : null,
      following: following ?? this.following,
      postcount: postcount ?? this.postcount,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      followingList: followersList ?? this.followersList,
      followersList: followersList ?? this.followersList,
    );
  }

  String getFollower() {
    return '${this.followers ?? 0}';
  }

  String getFollowing() {
    return '${this.following ?? 0}';
  }

  String getPostcount() {
    return '${this.postcount ?? 0}';
  }
}

UseR defaultUser({
  String userId,
  String email,
  String userName,
  String bio,
}) {
  return UseR(
      userId: userId,
      displayName: userName,
      email: email,
      bio: bio,
      profilePic: '',
      followers: 0,
      following: 0,
      followersList: [],
      followingList: [],
      postcount: 0);
}
