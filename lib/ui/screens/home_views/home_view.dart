import 'package:flutter/material.dart';
import 'package:projectnew/ui/screens/home_views/Feed_view.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';

import 'package:projectnew/ui/screens/home_views/Search_view.dart';

class HomeView extends StatefulWidget {
  final String fireBaseUserID;
  HomeView({@required this.fireBaseUserID});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
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
            FeedView(userId: userId),
            SearchView(userId: userId),
            ProfileView()
          ],
        ),
      ),
    );
  }
}
