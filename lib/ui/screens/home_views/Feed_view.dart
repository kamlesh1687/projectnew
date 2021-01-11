import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/utils/Widgets.dart';
import 'package:projectnew/utils/reusableWidgets/post_view.dart';

import 'Profile_view.dart';
import 'Search_view.dart';
import '../other_views/Uploadscreen_view.dart';
import 'package:projectnew/utils/reusableWidgets/customAppBar.dart';

class FeedView extends StatefulWidget {
  static const routeName = '/feedView';
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Building First Page");

    return Container(
      child: SafeArea(
        child: Stack(
          children: [FeedBody(), AppBarBtns()],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LeftBtnSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpecialButton(
      isRight: false,
      nextRoute: SearchView.routeName,
      icon: Icon(
        Icons.search,
        color: Colors.blueGrey,
      ),
    );
  }
}

class AppBarBtns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [LeftBtnSearchPage(), RightBtnUploadPage()],
    );
  }
}

class RightBtnUploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpecialButton(
      isRight: true,
      nextRoute: UploadScreen.routeName,
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.blueGrey,
      ),
    );
  }
}

class FeedBody extends StatefulWidget {
  @override
  _FeedBodyState createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
  var _refressIndicator = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    bool isEmpty = false;
    if (isEmpty) {
      return Center(child: Text('Feed is empty'));
    }

    print('list building');
    return Scaffold(
        appBar: customAppBar('LetStalk', context),
        body: Column(
          children: [
            Builder(builder: (context) {
              bool isBusy = false;
              if (isBusy) {
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
                key: _refressIndicator,
                color: Colors.teal,
                onRefresh: () => null,
                child: ListView.builder(
                  key: UniqueKey(),
                  shrinkWrap: true,
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostView(
                          profileTapFunc: () {
                            Navigator.pushNamed(context, ProfileView.routeName);
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
