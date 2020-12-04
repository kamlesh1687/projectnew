import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projectnew/business_logics/models/feedModel.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final String userId;
  PostView(this.userId);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Provider.of<FeedViewModel>(context, listen: false).createFeed();
    super.initState();
  }

  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Building First Page");

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('LetsTalk'),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: FeedBuilder(
            userId: widget.userId,
          ),
        ));
  }
}

class FeedBuilder extends StatelessWidget {
  final userId;

  const FeedBuilder({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("building timeline");
    return Consumer<FeedViewModel>(
      builder: (_, _value, __) {
        return _value.feedLoadingStatus == FeedLoadingStatus.Loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: RefreshIndicator(
                  color: Colors.teal,
                  onRefresh: Provider.of<FeedViewModel>(context, listen: false)
                      .onRefress,
                  child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: _value.feedList?.length ?? 0,
                    itemBuilder: (context, index) {
                      FeeD _feedData = _value.feedList[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardContainer(
                            values: CrdConValue(
                              color: Theme.of(context).cardColor,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<ProfileViewModel>(
                                                          context,
                                                          listen: false)
                                                      .eventLoadingStatus =
                                                  EventLoadingStatus.Loading;
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return ProfileView(
                                                    true,
                                                    userId: _feedData.ownerId,
                                                  );
                                                },
                                              ));
                                            },
                                            child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        _feedData.profileUrl)),
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
                                                    _feedData.displayName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(_feedData.location,
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
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          child: CachedNetworkImage(
                                            imageUrl: _feedData.postUrl,
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
                                                  icon: Icon(Icons
                                                      .comment_bank_outlined),
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
                                            child: Text(_feedData.postCaption),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              );
      },
    );
  }
}
