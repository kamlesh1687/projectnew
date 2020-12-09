import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectnew/business_logics/models/feedModel.dart';
import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/reusableWidgets/PageRoute.dart';
import 'package:provider/provider.dart';

import '../other_views/Uploadscreen_view.dart';

class FeedView extends StatefulWidget {
  final String userId;
  FeedView(this.userId);
  @override
  _FeedViewState createState() => _FeedViewState(userId);
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  final String userId;

  _FeedViewState(this.userId);
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
        body: SafeArea(child: Consumer<FeedViewModel>(
          builder: (_, _value, __) {
            return _value.feedLoadingStatus == FeedLoadingStatus.Loading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      SpecialButton(
                        isCurrentuser: true,
                        right: 0,
                        color: Colors.white,
                        clickFunction: () {
                          Navigator.push(
                              context,
                              MyCustomPageRoute(
                                  previousPage: FeedView(
                                    widget.userId,
                                  ),
                                  builder: (context) =>
                                      UploadScreen(widget.userId)));
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'LetStalk',
                                  style: Theme.of(context).textTheme.headline3,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              color: Colors.teal,
                              onRefresh: Provider.of<FeedViewModel>(context,
                                      listen: false)
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                              EventLoadingStatus
                                                                  .Loading;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return ProfileView(
                                                                true,
                                                                userId: _feedData
                                                                    .ownerId,
                                                              );
                                                            },
                                                          ));
                                                        },
                                                        child: CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                CachedNetworkImageProvider(
                                                                    _feedData
                                                                        .profileUrl)),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                _feedData
                                                                    .displayName,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  _feedData
                                                                      .location,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                          FontAwesomeIcons
                                                              .gripVertical),
                                                      onPressed: () {
                                                        print('More');
                                                      })
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              20,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            _feedData.postUrl,
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
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .thumbsUp),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          IconButton(
                                                              icon: Icon(
                                                                  FontAwesomeIcons
                                                                      .comment),
                                                              onPressed: () {}),
                                                        ],
                                                      ),
                                                      Text("15 Likes"),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(_feedData
                                                            .postCaption),
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
                          ),
                        ],
                      ),
                    ],
                  );
          },
        )));
  }
}
