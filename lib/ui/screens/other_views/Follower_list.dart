import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/UserProfileModel.dart';

import 'package:projectnew/ui/screens/home_views/Profile_view.dart';
import 'package:projectnew/ui/screens/home_views/Search_view.dart';

class Usermodel {}

class ListFollowers extends StatelessWidget {
  final int initialIndex;
  final String title;
  final String userId;
  ListFollowers(
      {@required this.initialIndex,
      @required this.title,
      @required this.userId});

  @override
  Widget build(BuildContext context) {
    print(userId);
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Followers',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Tab(
                child: Text('Following', style: TextStyle()),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FollowersListBuilder(
              list: 'followerList',
              userId: userId,
            ),
            FollowersListBuilder(userId: userId, list: 'followingList')
          ],
        ),
      ),
    );
  }
}

class FollowersListBuilder extends StatefulWidget {
  final String userId;
  final String list;
  FollowersListBuilder({@required this.userId, @required this.list});
  @override
  FollowersListBuilderState createState() =>
      FollowersListBuilderState(userId: userId, list: list);
}

class FollowersListBuilderState extends State<FollowersListBuilder>
    with AutomaticKeepAliveClientMixin {
  final String userId;
  final String list;
  FollowersListBuilderState({@required this.userId, @required this.list});
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('$userId')
          .collection('$list')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            List<QueryDocumentSnapshot> userlist = snapshot.data.docs;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                  itemCount: userlist.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userlist[index].id.toString())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData || snapshot.data != null) {
                              UseR followersList =
                                  UseR.fromJson(snapshot.data.data());
                              return GestureDetector(
                                onTap: () {
                                  print("loading");

                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ProfileView(
                                        loadAgain: true,
                                        userId: followersList.userId,
                                      );
                                    },
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: CustomCardUserList(
                                      userList: followersList),
                                ),
                              );
                            }
                          }
                          return Container();
                        });
                  }),
            );
          }
          return Center(child: Text('No data'));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
