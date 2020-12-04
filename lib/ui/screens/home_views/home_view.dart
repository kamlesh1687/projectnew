import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/view_models/Profile_viewmodel.dart';

import 'package:projectnew/ui/screens/home_views/Feed_view.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:projectnew/ui/screens/home_views/Search_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final String fireBaseUserID;
  HomeView({@required this.fireBaseUserID});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var _value = context.read<ProfileViewModel>();
      print("getting userData ");
      _value.getUserProfileData(widget.fireBaseUserID);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    print("Building HomeView");

    return HomeNavScreen(widget.fireBaseUserID);
  }
}

class HomeNavScreen extends StatelessWidget {
  final String userId;
  HomeNavScreen(this.userId);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          labelColor: Colors.black,
          automaticIndicatorColorAdjustment: true,
          isScrollable: false,
          tabs: [
            Tab(icon: Icon(Icons.home_outlined)),
            Tab(
              icon: Icon(Icons.search_outlined),
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            FeedView( userId),
            SearchView(userId: userId),
            ProfileView(false)
          ],
        ),
      ),
    );
  }
}
