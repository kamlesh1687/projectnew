import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_view.dart';
import 'package:projectnew/utils/models/userModel.dart';

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
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Followers'),
              ),
              Tab(
                child: Text('Following'),
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

            return ListView.builder(
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
                                UseR.fromDocument(snapshot.data);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ProfileView(followersList.userId);
                                  },
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, bottom: 5),
                                child: new ListTile(
                                  tileColor: Theme.of(context).cardColor,
                                  leading: CircleAvatar(
                                    child: CachedNetworkImage(
                                      imageUrl: followersList.photoUrl,
                                    ),
                                  ),
                                  title: new Text(followersList.displayName),
                                  subtitle: new Text(followersList.userEmail),
                                ),
                              ),
                            );
                          }
                        }
                        return Container();
                      });
                });
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
