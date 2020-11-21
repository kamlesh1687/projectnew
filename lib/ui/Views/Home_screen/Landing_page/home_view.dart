import 'package:flutter/material.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Feed_page/Feed_view.dart';

import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_view.dart';
import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Profile_page/new.dart';

import 'package:projectnew/ui/Views/Home_screen/Nav_Pages/Search_page/Search_view.dart';

class HomeView extends StatelessWidget {
  final String fireBaseUserID;
  HomeView({@required this.fireBaseUserID});

  Widget build(BuildContext context) {
    print("Building HomeView");

    return HomeNavScreen(fireBaseUserID);
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
          children: [
            FeedView(userId: userId),
            SearchView(userId: userId),
            ProfileView(userId: userId)
          ],
        ),
      ),
    );
  }
}
