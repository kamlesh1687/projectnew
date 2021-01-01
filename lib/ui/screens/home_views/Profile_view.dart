import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/business_logics/models/postModel.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';

import 'package:projectnew/ui/screens/other_views/Chat_view.dart';
import 'package:projectnew/ui/screens/other_views/Profile_editview.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';
import 'package:projectnew/utils/properties.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String userId;
  final bool loadAgain;

  ProfileView({
    this.loadAgain,
    this.userId,
  });

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isMe;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    var currentUserId = FirebaseAuth.instance.currentUser.uid;
    var _value = context.read<ProfileViewModel>();

    isMe = widget.userId == null || widget.userId == currentUserId;

    if (widget.loadAgain != null && widget.loadAgain) {
      _value.getUserDataOnline(widget.userId);
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
      key: _scaffoldKey,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
            child: Stack(
          children: [
            Consumer<ProfileViewModel>(builder: (_, value, __) {
              if (value.profileLoadingStatus == EventLoadingStatus.Loaded) {
                return ProfileViewContent(
                    bodySection: bodySection(), headerSection: headerSection());
              }
              return Center(child: CircularProgressIndicator());
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isMe
                    ? Container(
                        height: 1,
                      )
                    : SpecialButton(
                        isRight: isMe,
                        specialBtnaction: "MayBePop",
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blueGrey,
                        ),
                      ),
                isMe
                    ? SpecialButton(
                        isRight: isMe,
                        nextScreen: ProfileEditView(),
                        icon: Icon(
                          Icons.edit_sharp,
                          color: Colors.blueGrey,
                        ),
                      )
                    : Container(
                        height: 1,
                      ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget countRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
            if (_value.profileUser?.userData == null) {
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
                            text: _value.profileUser.userData.getFollower() +
                                "\n",
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
            if (_value.profileUser?.userData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return TextButton(
              onPressed: () {
                print(_value.profileUser.userData.following);
                print(_value.myProfileData.userData.following);
              },
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
                          text:
                              _value.profileUser.userData.getFollowing() + "\n",
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
            if (_value.profileUser?.userData == null) {
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
                            text: _value.profileUser.userData.getPostcount() +
                                "\n",
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
                if (_value.profileUser?.userData == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return Text(_value.profileUser.userData.bio ?? "",
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
                      if (_value.profileUser?.userData == null) {
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
                          txt: _value.isFollower() ? 'Following' : 'Follow',
                        );
                    })),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CircularBtn(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatView(
                                userData: context
                                    .read<ProfileViewModel>()
                                    .profileUser
                                    .userData,
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

class ProfileViewContent extends StatelessWidget {
  final bodySection;
  final headerSection;

  const ProfileViewContent(
      {Key key, @required this.bodySection, @required this.headerSection})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<ProfileViewModel>(builder: (_, _value, __) {
            return SingleChildScrollView(
                child: Column(
              children: [
                _value.isbusy
                    ? Container(
                        height: 20,
                        child: Center(child: LinearProgressIndicator()))
                    : SizedBox.shrink(),
                headerSection,
                SizedBox(
                  height: 10,
                ),
                bodySection,
                SizedBox(
                  height: 10,
                ),
                PostGridView()
              ],
            ));
          }),
        ));
  }
}

class PostGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _value = context.watch<ProfileViewModel>();

    if (_value.isLoadingPost) {
      return Container(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_value.profileUser?.postList != null &&
        _value.profileUser.postList.length <= 0) {
      return Column(
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
                      text: _value.profileUser.userData.displayName,
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
      );
    } else
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: Properties().borderRadius),
        padding: EdgeInsets.all(4),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _value.profileUser.postList?.length ?? 0,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            PosT _post = _value.profileUser.postList[index];

            return Container(
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: _post.postimageurl,
                ),
              ),
            );
          },
        ),
      );
  }
}

class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<ProfileViewModel>().profileUser?.userData;
    return _userData == null
        ? CircularProgressIndicator()
        : Container(
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(borderRadius: Properties().borderRadius),
            child: ClipRRect(
                borderRadius: Properties().borderRadius,
                child: CachedNetworkImage(
                    imageUrl: _userData.profilePic,
                    useOldImageOnUrlChange: true,
                    imageBuilder: (context, imageProvider) {
                      if (imageProvider == null) {
                        return FittedBox(
                            child: Icon(
                          FontAwesomeIcons.user,
                        ));
                      }
                      return Image(
                        image: imageProvider,
                      );
                    },
                    errorWidget: (context, url, error) {
                      return FittedBox(
                          child: Icon(
                        FontAwesomeIcons.questionCircle,
                      ));
                    },
                    placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                    fit: BoxFit.cover)));
  }
}

class UserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UseR _userData = context.watch<ProfileViewModel>().profileUser?.userData;
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

/* ------------------------------- end of page ------------------------------ */
