import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:projectnew/business_logics/view_models/Search_viewmodel.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:projectnew/utils/Theming/Style.dart';
import 'package:projectnew/utils/Widgets.dart';

import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final String userId;
  SearchView({@required this.userId});
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("building ThirdView");
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CardContainer(
              values: CrdConValue(
                linearGradient:
                    Provider.of<ThemeModelProvider>(context).curretGradient,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Searchtextfield(
                    hinttext: 'Search',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(child: UserList())
          ],
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var value = Provider.of<SearchViewModel>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: value.searchedName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (snapshot.data != null && value.searchedName != '') {
              return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                UseR searchUserList = UseR.fromJson(document.data());

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<ProfileViewModel>(context, listen: false)
                          .eventLoadingStatus = EventLoadingStatus.Loading;
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfileView(
                            userId: searchUserList.userId,
                          );
                        },
                      ));
                    },
                    child: CustomCardUserList(
                      userList: searchUserList,
                    ),
                  ),
                );
              }).toList());
            }

            return Center(
              child: Text('No User Found'),
            );
          }
          return Center(child: Text('No data'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CustomCardUserList extends StatelessWidget {
  final UseR userList;
  final followBtn;

  const CustomCardUserList({Key key, @required this.userList, this.followBtn})
      : super(key: key);

  isFollower(uid, context, _data) {
    if (_data.profileUserModel.followingList != null &&
        _data.profileUserModel.followersList.isNotEmpty) {
      return (_data.profileUserModel.followingList.any((x) => x == uid));
    } else {
      print('not following');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String _myUserId = context.watch<ProfileViewModel>().myUid;
    print(userList.displayName);
    return CardContainer(
      values: CrdConValue(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      CachedNetworkImageProvider(userList?.profilePic),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            userList.displayName,
                            style: Style().cardTitle,
                          ),
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: context
                                    .watch<ThemeModelProvider>()
                                    .curretGradient),
                            child: _myUserId == userList.userId
                                ? Container()
                                : FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(context
                                            .watch<ProfileViewModel>()
                                            .isFollowed(userList)
                                        ? "Following"
                                        : "Follow"),
                                    onPressed: () {
                                      context
                                          .read<ProfileViewModel>()
                                          .followUserListBtn(userList,
                                              removeFollower: context
                                                  .read<ProfileViewModel>()
                                                  .isFollowed(userList));
                                    },
                                  ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        userList.email,
                        style: Style().cardSubTitle,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          )),
    );
  }
}

class Searchtextfield extends StatelessWidget {
  final hinttext;
  Searchtextfield({@required this.hinttext});

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<SearchViewModel>(context);
    return Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: TextField(
                style: TextStyle(fontSize: 20),
                onChanged: (txt) {
                  value.searchedName = value.searchInputText.text;
                },
                controller: value.searchInputText,
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: value.searchedName != ''
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            value.searchedName = '';
                            value.searchInputText.clear();
                          })
                      : Container(
                          width: 1,
                        ),
                  hintText: hinttext,
                  alignLabelWithHint: true,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ));
  }
}
