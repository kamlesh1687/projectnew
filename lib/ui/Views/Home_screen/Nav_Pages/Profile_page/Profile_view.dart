import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/EditProfile/Profile_editview.dart';
import 'package:projectnew/ui/Views/Home_screen/FollowerList_page/Follower_list.dart';
import 'package:projectnew/ui/Views/Home_screen/Message_screen/Chat_view.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/models/userModel.dart';

import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String _userId;

  ProfileView(this._userId);
  @override
  _ProfileViewState createState() => _ProfileViewState(_userId);
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  final String _userId;
  _ProfileViewState(this._userId);
  bool isCurrentUser;
  String currentUserId;

  @override
  Widget build(BuildContext context) {
    var _valueProvider = Provider.of<ProfileViewModel>(context, listen: false);
    super.build(context);
    print("building Profile");
    currentUserId = FirebaseAuth.instance.currentUser.uid;
    if (_userId == currentUserId) {
      isCurrentUser = true;
    } else {
      isCurrentUser = false;
    }
    _valueProvider.getdatafromfirebase(_userId, isCurrentUser);
    return Scaffold(body: SafeArea(
        child: Consumer<ProfileViewModel>(builder: (context, userData, __) {
      return userData.eventLoadingStatus == EventLoadingStatus.Loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProfileBody(
              currentUserId: currentUserId,
              userProfileData: userData.userProfileData,
              isCurrentUser: isCurrentUser,
              userId: _userId,
            );
    })));
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileBody extends StatelessWidget {
  final isCurrentUser;
  final UseR userProfileData;
  final userId;
  final currentUserId;

  const ProfileBody(
      {Key key,
      this.isCurrentUser,
      this.userProfileData,
      this.userId,
      this.currentUserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(userProfileData.displayName);
    return Stack(
      children: [
        isCurrentUser
            ? SpecialButton(
                isCurrentuser: isCurrentUser,
                right: 0,
                color: Colors.white,
                clickFunction: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileEditView(
                      userProfileData,
                      userProfileData.userId,
                    );
                  }));
                },
                icon: Icon(
                  Icons.edit_sharp,
                  color: Colors.blueGrey,
                ),
              )
            : SpecialButton(
                isCurrentuser: isCurrentUser,
                left: 0,
                color: Colors.white,
                clickFunction: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blueGrey,
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              HeaderSection(
                isCurrentUser: isCurrentUser,
              ),
              SizedBox(
                height: 10,
              ),
              BodySection(
                currentUserId: currentUserId,
                isCurrentUser: isCurrentUser,
                userId: userId,
              ),
              Expanded(child: Container()),
              isCurrentUser
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: InkWell(
                        child: CardContainer(
                          color: Colors.red.shade200,
                          color2: Colors.deepOrange.shade300,
                          widget: Center(
                            child: Text(
                              "LogOut",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class FollowCount extends StatelessWidget {
  final String collection;
  final String userId;
  FollowCount(this.userId, this.collection);

  Widget countText(var count, context) {
    return Text('$count', style: Theme.of(context).textTheme.headline6);
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    var _streamsProvider =
        Provider.of<ProfileViewModel>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: _streamsProvider.getFollowCount(userId, collection),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            count = snapshot.data.docs.length;
            return countText(count, context);
          }
          return countText(count, context);
        }
        return countText(count, context);
      },
    );
  }
}

class FollowUnfollow extends StatelessWidget {
  final String userId;
  final String otherUserId;

  //  var unfollowfinction;
  FollowUnfollow({
    @required this.userId,
    @required this.otherUserId,
  });

  Widget followButton(var btnText, var onClick) {
    return RaisedButton(
      color: Colors.cyan.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: onClick,
      padding: EdgeInsets.all(12),
      child: Text(
        btnText,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _streamsProvider =
        Provider.of<ProfileViewModel>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: _streamsProvider.getFollowState(otherUserId, userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data.exists) {
              return followButton("Unfollow", () {
                _streamsProvider.removeFollower(userId, otherUserId);
              });
            } else {
              return followButton("Follow", () {
                _streamsProvider.updateFollowers(userId, otherUserId);
              });
            }
          }
        }
        return followButton("", () {});
      },
    );
  }
}

class ProfileImage extends StatelessWidget {
  final isCurrentUser;
  final imageWidget;

  const ProfileImage({Key key, this.isCurrentUser, this.imageWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 15,
            spreadRadius: 2)
      ], borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: imageWidget,
      ),
    );
  }
}

class UserName extends StatelessWidget {
  final userName;

  const UserName({Key key, this.userName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5 - 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(userName, style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final isCurrentUser;

  const HeaderSection({Key key, @required this.isCurrentUser})
      : super(key: key);

  Widget profilePic(var _user) {
    return ProfileImage(
      imageWidget: CachedNetworkImage(
          imageUrl: _user.userProfileData.photoUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          fit: BoxFit.cover),
      isCurrentUser: isCurrentUser,
    );
  }

  Widget userName(var _user) {
    return UserName(userName: _user.userProfileData.displayName);
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<ProfileViewModel>(
      context,
    );

    return Container(
      height: 145,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isCurrentUser ? profilePic(_user) : userName(_user),
          !isCurrentUser ? profilePic(_user) : userName(_user)
        ],
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  final userId;
  final isCurrentUser;
  final currentUserId;

  const BodySection(
      {Key key,
      @required this.userId,
      @required this.isCurrentUser,
      @required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<ProfileViewModel>(
      context,
    );
    return Column(
      children: [
        CardContainer(
          color: Theme.of(context).cardColor,
          color2: Theme.of(context).cardColor,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_user.userProfileData.userDescription,
                softWrap: true,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CardContainer(
          color: Theme.of(context).cardColor,
          color2: Theme.of(context).cardColor,
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FollowCountBtn(
                  routeWidget: ListFollowers(
                      initialIndex: 0,
                      title: _user.userProfileData.displayName,
                      userId: _user.userProfileData.userId),
                  userId: userId,
                  listType: 'followerList',
                  btnText: "Followers"),
              FollowCountBtn(
                  routeWidget: ListFollowers(
                      initialIndex: 1,
                      title: _user.userProfileData.displayName,
                      userId: _user.userProfileData.userId),
                  userId: userId,
                  listType: 'followingList',
                  btnText: "Following"),
            ],
          ),
        ),
        !isCurrentUser
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: FollowUnfollow(
                          userId: currentUserId, otherUserId: userId),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(12),
                        color: Colors.cyan.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatView(
                              userData: _user.userProfileData,
                              currenUserId: currentUserId,
                            );
                          }));
                        },
                        child: Text(
                          "Message",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

class FollowCountBtn extends StatelessWidget {
  final routeWidget;
  final userId;
  final listType;
  final btnText;

  const FollowCountBtn(
      {Key key,
      @required this.routeWidget,
      @required this.userId,
      @required this.listType,
      @required this.btnText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return routeWidget;
          },
        ));
      },
      child: Column(
        children: [
          FollowCount(userId, listType),
          Text(
            btnText,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
