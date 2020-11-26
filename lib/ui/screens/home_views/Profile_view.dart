import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:projectnew/business_logic/view_models/Splash_screenmodel.dart';
import 'package:projectnew/ui/screens/other_views/Chat_view.dart';
import 'package:projectnew/ui/screens/other_views/Profile_editview.dart';
import 'package:projectnew/ui/screens/other_views/Follower_list.dart';

import 'package:projectnew/business_logic/view_models/Profile_viewmodel.dart';

import 'package:projectnew/utils/Theming/Style.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/business_logic/models/userModel.dart';
import 'package:projectnew/utils/reusableWidgets/PageRoute.dart';

import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String userId;

  ProfileView({
    this.userId,
  });

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isMe;
  void initState() {
    var currentUserId = FirebaseAuth.instance.currentUser.uid;
    isMe = widget.userId == null || widget.userId == currentUserId;

    if (!isMe) {
      print("getting other user data");
      var _value = context.read<SplashScreenModel>();

      _value.getProfileData(userid: widget.userId);
    }

    super.initState();
  }

  Future<bool> _onWillPop() async {
    print("onwillPop");
    Provider.of<SplashScreenModel>(context, listen: false).removeLastUser();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("user id ${widget.userId}");

    print("building Profile Check");

    return Scaffold(
        body: SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer<SplashScreenModel>(builder: (_, _value, __) {
          return _value.loadingStatus == LoadingStatus.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                )
              : Stack(
                  children: [
                    isMe
                        ? SpecialButton(
                            isCurrentuser: isMe,
                            right: 0,
                            color: Colors.white,
                            clickFunction: () {
                              Navigator.push(
                                  context,
                                  MyCustomPageRoute(
                                      previousPage: ProfileView(
                                        userId: widget.userId,
                                      ),
                                      builder: (context) => ProfileEditView()));
                            },
                            icon: Icon(
                              Icons.edit_sharp,
                              color: Colors.blueGrey,
                            ),
                          )
                        : SpecialButton(
                            isCurrentuser: isMe,
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            HeaderSection(),
                            SizedBox(
                              height: 10,
                            ),
                            BodySection(
                              isCurrentUser: isMe,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    ));
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ProfileImage(), UserName()],
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  final bool isCurrentUser;

  const BodySection({Key key, this.isCurrentUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<SplashScreenModel>().profileUserModel;

    return _userData == null
        ? CircularProgressIndicator()
        : Column(
            children: [
              CardContainer(
                values: CrdConValue(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(_userData?.userDescription ?? "",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CardContainer(
                values: CrdConValue(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FollowCountBtn(
                            routeWidget: ListFollowers(
                                initialIndex: 0,
                                title: _userData.displayName,
                                userId: _userData.userId),
                            userId: _userData.userId,
                            listType: 'followerList',
                            btnText: "Followers"),
                        FollowCountBtn(
                            routeWidget: ListFollowers(
                                initialIndex: 1,
                                title: _userData.displayName,
                                userId: _userData.userId),
                            userId: _userData.userId,
                            listType: 'followingList',
                            btnText: "Following"),
                      ],
                    ),
                  ),
                ),
              ),
              !isCurrentUser
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: FollowUnfollow(
                                currntUserId: Provider.of<SplashScreenModel>(
                                        context,
                                        listen: false)
                                    .currentUserId,
                                otherUserId: _userData.userId),
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
                                    userData: _userData,
                                    currenUserId:
                                        Provider.of<SplashScreenModel>(context,
                                                listen: false)
                                            .currentUserId,
                                  );
                                }));
                              },
                              child: Text(
                                "Message",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
  final String currntUserId;
  final String otherUserId;

  //  var unfollowfinction;
  FollowUnfollow({
    @required this.currntUserId,
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
      stream: _streamsProvider.getFollowState(otherUserId, currntUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data.exists) {
              return followButton("Unfollow", () {
                _streamsProvider.removeFollower(currntUserId, otherUserId);
              });
            } else {
              return followButton("Follow", () {
                _streamsProvider.updateFollowers(currntUserId, otherUserId);
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
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<SplashScreenModel>().profileUserModel;
    return _userData == null
        ? CircularProgressIndicator()
        : Container(
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 15,
                  spreadRadius: 2)
            ], borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    imageUrl: _userData.photoUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    fit: BoxFit.cover)));
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<SplashScreenModel>().profileUserModel;
    return _userData == null
        ? CircularProgressIndicator()
        : Container(
            width: MediaQuery.of(context).size.width * 0.5 - 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_userData.displayName, style: Style().profileName),
            ),
          );
  }
}
