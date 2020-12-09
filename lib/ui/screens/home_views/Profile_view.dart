import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/business_logics/models/postModel.dart';

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
  final UseR userData;

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SafeArea(
              child: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
                    return _value.eventLoadingStatus ==
                            EventLoadingStatus.Loading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.amber,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                            children: [
                              headerSection(),
                              SizedBox(
                                height: 10,
                              ),
                              bodySection(),
                              SizedBox(
                                height: 10,
                              ),
                              PostGridView()
                            ],
                          ));
                  }),
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
          ))),
    );
  }

  Widget countRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
            if (_value.profileUserModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return TextButton(
                style: ButtonStyle(
                  enableFeedback: true,
                ),
                onPressed: () {},
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Opacity(
                          child: Icon(
                            FontAwesomeIcons.user,
                            size: 50,
                            color: Colors.grey,
                          ),
                          opacity: 0.06,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Followers",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 14,
                                      color: Colors.grey))
                            ],
                            style: Theme.of(context).textTheme.headline5,
                            text: _value.profileUserModel.getFollower() + "\n",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }),
        ),
        Expanded(
          child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
            if (_value.profileUserModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return TextButton(
                onPressed: () {},
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Opacity(
                          child: Icon(
                            FontAwesomeIcons.user,
                            size: 50,
                            color: Colors.grey,
                          ),
                          opacity: 0.06,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Following",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 14,
                                      color: Colors.grey))
                            ],
                            style: Theme.of(context).textTheme.headline5,
                            text: _value.profileUserModel.getFollowing() + "\n",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }),
        ),
        Expanded(
          child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
            if (_value.profileUserModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return TextButton(
                onPressed: () {},
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Opacity(
                          child: Icon(
                            FontAwesomeIcons.fileImage,
                            size: 50,
                            color: Colors.grey,
                          ),
                          opacity: 0.06,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Photos",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 14,
                                      color: Colors.grey))
                            ],
                            style: Theme.of(context).textTheme.headline5,
                            text: "2\n",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }),
        ),
      ],
    );
  }

  Widget bodySection() {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: countRow()),
        CardContainer(
          values: CrdConValue(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
                if (_value.profileUserModel == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return Text(_value.profileUserModel.bio ?? "",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                      ));
              }),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        !isMe
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(child:
                        Consumer<ProfileViewModel>(builder: (_, _value, __) {
                      if (_value.profileUserModel == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else
                        return CircularBtn(
                          onPressed: () {
                            _value.followUser(
                              removeFollower: _value.isFollower(),
                            );
                          },
                          borderRadius: 50.0,
                          txt: _value.isFollower() ? 'Following' : 'Follow',
                        );
                    })),
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
                                userData: context
                                    .read<ProfileViewModel>()
                                    .profileUserModel,
                                currenUserId: null);
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

  Widget headerSection() {
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

class PostGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _value = context.watch<ProfileViewModel>();
    return _value.postGrids.length <= 0
        ? Column(
            children: [
              Container(
                child: Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      FontAwesomeIcons.images,
                      size: 100,
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: 'When ',
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                          text: _value.profileUserModel.displayName,
                          style: Theme.of(context).textTheme.bodyText1,
                          children: [
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyText2,
                                text:
                                    " share photos and videos, they'll appear here")
                          ]),
                    ]),
              ),
            ],
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _value.postGrids?.length ?? 0,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              PosT _post = _value.postGrids[index];

              return Container(
                padding: EdgeInsets.all(2),
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
