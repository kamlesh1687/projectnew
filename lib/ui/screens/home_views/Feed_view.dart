import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/postModel.dart';

import 'package:projectnew/business_logics/view_models/Feed_viewmodel.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';
import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/reusableWidgets/post_view.dart';
import 'package:provider/provider.dart';

import 'Profile_view.dart';
import 'Search_view.dart';
import '../other_views/Uploadscreen_view.dart';
import 'package:projectnew/utils/reusableWidgets/customAppBar.dart';

class FeedView extends StatefulWidget {
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    print("Building First Page");
    var _userId = Provider.of<ProfileViewModel>(context).userID;

    return Container(
      child: SafeArea(
        child: Stack(
          children: [
            FeedBody(
              userId: _userId,
            ),
            AppBarBtns(
              userId: _userId,
            )
          ],
        ),
      ),
    );
  }
}

class LeftBtnSearchPage extends StatelessWidget {
  final userId;

  const LeftBtnSearchPage({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpecialButton(
      isRight: false,
      nextScreen: SearchView(),
      icon: Icon(
        Icons.search,
        color: Colors.blueGrey,
      ),
    );
  }
}

class AppBarBtns extends StatelessWidget {
  final userId;

  const AppBarBtns({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LeftBtnSearchPage(
          userId: userId,
        ),
        RightBtnUploadPage(
          userId: userId,
        )
      ],
    );
  }
}

class RightBtnUploadPage extends StatelessWidget {
  final userId;

  const RightBtnUploadPage({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpecialButton(
      isRight: true,
      nextScreen: UploadScreen(userId),
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.blueGrey,
      ),
    );
  }
}

class FeedBody extends StatefulWidget {
  final String userId;
  const FeedBody({Key key, this.userId}) : super(key: key);
  @override
  _FeedBodyState createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  @override
  Widget build(BuildContext context) {
    var _value = context.watch<FeedViewModel>();
    if (_value.feedLoadingStatus == EventLoadingStatus.Loading) {
      return Center(child: CircularProgressIndicator());
    }
    print('list building');
    return Scaffold(
        appBar: customAppBar('LetStalk', context),
        body: Column(
          children: [
            Consumer<FeedViewModel>(builder: (_, value, __) {
              if (value.isbusy) {
                return Container(
                  height: 20,
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
            Expanded(
              child: RefreshIndicator(
                color: Colors.teal,
                onRefresh: () =>
                    context.read<FeedViewModel>().createFeed(widget.userId),
                child: ListView.builder(
                  key: UniqueKey(),
                  shrinkWrap: true,
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: true,
                  itemCount: _value.feedList?.length ?? 0,
                  itemBuilder: (context, index) {
                    PosT _feedData = _value.feedList[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostView(
                          postData: _feedData,
                          profileTapFunc: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ProfileView(
                                  loadAgain: true,
                                  userId: _feedData.ownerId,
                                );
                              },
                            ));
                          },
                        ));
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
