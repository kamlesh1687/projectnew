import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/features/data/models/userProfile.dart';
import 'package:projectnew/features/presentation/providers/profileNotifier.dart';

import 'package:projectnew/ui/screens/other_views/Chat_view.dart';
import 'package:projectnew/ui/screens/other_views/Profile_editview.dart';
import 'package:projectnew/utils/State_management/state.dart';

import 'package:projectnew/utils/Widgets.dart';

import 'package:projectnew/utils/properties.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profileView';
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isMe = true;
    return WillPopScope(
      onWillPop: () async {
        return null;
      },
      key: _scaffoldKey,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
            child: Stack(
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.read<ProfileNotifier>().getUserData();
                },
              ),
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: Consumer<ProfileNotifier>(builder: (_, state, __) {
                switch (state.userDataCase.state) {
                  case ResponseState.ERROR:
                    return Text(state.userDataCase.exception);
                    break;
                  case ResponseState.LOADING:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ResponseState.COMPLETE:
                    return ProfileViewContent(
                        bodySection: ProfileViewBody(
                          isMe: isMe,
                        ),
                        headerSection: ProfileViewHeader(
                          isMe: isMe,
                        ));
                    break;
                  default:
                }
                return Container();
              }),
            ),

            // Consumer<ProfileViewModel>(builder: (_, value, __) {
            //   if (value.profileLoadingStatus == EventLoadingStatus.Loaded) {
            //     return ProfileViewContent(
            //         bodySection: ProfileViewBody(
            //           isMe: isMe,
            //           userData: value.profileUser.userData,
            //         ),
            //         headerSection: ProfileViewHeader(
            //           isMe: isMe,
            //           userData: value.profileUser.userData,
            //         ));
            //   }
            //   return Center(child: CircularProgressIndicator());
            // }),
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
                        nextRoute: ProfileEditView.routeName,
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
}

class ProfileViewHeader extends StatelessWidget {
  final bool isMe;

  const ProfileViewHeader({
    Key key,
    this.isMe,
  }) : super(key: key);
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

class ProfileViewContent extends StatelessWidget {
  final ProfileUser profileUser;
  final bodySection;
  final headerSection;

  const ProfileViewContent(
      {Key key,
      @required this.bodySection,
      @required this.headerSection,
      this.profileUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
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
        )));
  }
}

class ProfileViewCountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: TextButton(
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
                    opacity: 0.2,
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
                      text: context.watch<ProfileNotifier>().followerCount,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
        Expanded(
            child: TextButton(
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
                    opacity: 0.2,
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
                      text: context.watch<ProfileNotifier>().followingCount,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
        Expanded(
            child: TextButton(
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
                    opacity: 0.2,
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
                      text: '0',
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class PostGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = false;
    if (loading) {
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
                      text: 'UserName',
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
          itemCount: 3,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.red,
                ),
              ),
            );
          },
        ),
      );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(borderRadius: Properties().borderRadius),
        child: ClipRRect(
            borderRadius: Properties().borderRadius,
            child: Container(
              color: Colors.red,
              child: CachedNetworkImage(
                  imageUrl: context.watch<ProfileNotifier>().picUrl),
            )));
  }
}

class ProfileViewBody extends StatelessWidget {
  final bool isMe;

  const ProfileViewBody({Key key, this.isMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0), child: ProfileViewCountRow()),
        CardContainer(
          values: CrdConValue(
            color: Theme.of(context).cardColor,
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(context.watch<ProfileNotifier>().userBio,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 18,
                    ))),
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
                    Expanded(
                        child: CircularBtn(
                      onPressed: () {},
                      txt: 'Following',
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CircularBtn(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatView();
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

class UserName extends StatelessWidget {
  const UserName({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // String userName = 'username';

    return Container(
      width: MediaQuery.of(context).size.width * 0.5 - 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          context.watch<ProfileNotifier>().userName,
          style: Theme.of(context).textTheme.headline5,
          //  style: Style().profileName
        ),
      ),
    );
  }
}

/* ------------------------------- end of page ------------------------------ */
