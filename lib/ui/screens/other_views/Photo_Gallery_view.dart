import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projectnew/business_logics/models/postModel.dart';

class PostView extends StatefulWidget {
  final String userId;
  PostView(this.userId);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Building First Page");

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Posts",
          ),
        ),
        body: FeedBuilder(
          userId: widget.userId,
        ));
  }
}

class FeedBuilder extends StatelessWidget {
  final String userId;
  FeedBuilder({@required this.userId});
  @override
  Widget build(BuildContext context) {
    print("building timeline");
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('timeLine')
          .doc(userId)
          .collection('timeLinePosts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                PosT timelinepostlist = PosT.fromDocument(document);
                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 1,
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            timelinepostlist.ownername,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(timelinepostlist.postlocation,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(Icons.more_vert_rounded),
                                  onPressed: () {
                                    print('More');
                                  })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: CachedNetworkImage(
                                    imageUrl: timelinepostlist.postimageurl,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.thumb_up),
                                          onPressed: () {}),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          icon:
                                              Icon(Icons.comment_bank_outlined),
                                          onPressed: () {}),
                                    ],
                                  ),
                                  Text("15 Likes"),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(timelinepostlist.postdescription),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ));
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
