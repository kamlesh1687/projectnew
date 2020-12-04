import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/models/userModel.dart';

import 'package:projectnew/ui/screens/other_views/Chat_view.dart';
import 'package:projectnew/ui/screens/other_views/Profile_editview.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/utils/reusableWidgets/PageRoute.dart';

import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String userId;
  final bool load;
  final UserModel userData;

  ProfileView(this.load, {this.userId, this.userData});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isMe;

  void initState() {
    var currentUserId = FirebaseAuth.instance.currentUser.uid;
    isMe = widget.userId == null || widget.userId == currentUserId;
    if (widget.userData != null) {
      var _value = context.read<ProfileViewModel>();
      _value.eventLoadingStatus = EventLoadingStatus.Loading;
      _value.otheUserProfileData(widget.userData);
    }
    super.initState();
  }

  Future<bool> _onWillPop() async {
    Provider.of<ProfileViewModel>(context, listen: false).removeLastUser();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("user id ${widget.userId}");

    print("building Profile Check");

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(body: SafeArea(
        child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
          return _value.eventLoadingStatus == EventLoadingStatus.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              HeaderSection(isMe: isMe),
                              SizedBox(
                                height: 10,
                              ),
                              BodySection(
                                isCurrentUser: isMe,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              PostGridView()
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                        true,
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
                              Navigator.of(context).maybePop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.blueGrey,
                            ),
                          ),
                  ],
                );
        }),
      )),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final bool isMe;

  const HeaderSection({Key key, this.isMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isMe ? ProfileImage() : UserName(),
          !isMe ? ProfileImage() : UserName()
        ],
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  final bool isCurrentUser;

  const BodySection({Key key, this.isCurrentUser}) : super(key: key);

  isFollower(context) {
    var _data = Provider.of<ProfileViewModel>(context, listen: false);
    if (_data.profileUserModel.followersList != null &&
        _data.profileUserModel.followersList.isNotEmpty) {
      print("isFolloer" + _data.profileUserModel.followers.toString());
      return (_data.profileUserModel.followersList
          .any((x) => x == _data.userModel.userId));
    } else {
      print('not following');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _value = context.watch<ProfileViewModel>();
    UseR _userData = _value.profileUserModel;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    enableFeedback: true,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Follower\n" + _userData.followers.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                    // style: Style().bodyText,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Following\n" + _userData?.following.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                    // style: Style().bodyText
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Post\n",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,

                    // style: Style().bodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
        CardContainer(
          values: CrdConValue(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(_userData?.bio ?? "",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        !isCurrentUser
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: CircularBtn(
                      onPressed: () {
                        // context
                        //     .read<ProfileViewModel>()
                        //     .followBtn(followStatus, _userData.userId);
                        context.read<ProfileViewModel>().followUser(
                              removeFollower: isFollower(context),
                            );
                      },
                      borderRadius: 50.0,
                      txt: isFollower(context) ? 'Following' : 'Follow',
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CircularBtn(
                        borderRadius: 50.0,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatView(
                                userData: _userData, currenUserId: null);
                          }));
                        },
                        txt: "Message",
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

class PostGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _value = context.watch<ProfileViewModel>();
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _value.postGrids?.length ?? 0,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        PosT _post = _value.postGrids[index];

        return Container(
          child: CachedNetworkImage(
            imageUrl: _post.postimageurl,
          ),
        );
      },
    );
  }
}

class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<ProfileViewModel>().profileUserModel;
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
                    imageUrl: _userData.profilePic,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    fit: BoxFit.cover)));
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<ProfileViewModel>().profileUserModel;
    return _userData == null
        ? CircularProgressIndicator()
        : Container(
            width: MediaQuery.of(context).size.width * 0.5 - 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _userData.displayName,
                style: Theme.of(context).textTheme.headline5,
                //  style: Style().profileName
              ),
            ),
          );
  }
}

/* ------------------------------- sdfnaksdjkf ------------------------------ */
